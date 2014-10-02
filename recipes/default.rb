#
# Cookbook Name:: keboola-connection
# Recipe:: default
#


include_recipe "aws"
include_recipe "keboola-common"
include_recipe "keboola-connection::php"
include_recipe "keboola-apache2"
include_recipe "newrelic::php_agent"

# required for mysql exports using command line
package "mysql-common"
package "mysql55"



# tools required for build
include_recipe "nodejs"
package "ant"

execute "npm modules" do
  command "npm install -g bower grunt-cli"
end


aws_s3_file "/root/.ssh/kbc_id_rsa" do
  bucket "keboola-configs"
  remote_path "deploy-keys/kbc_id_rsa"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
  owner "root"
  group "root"
  mode "0600"
end


cookbook_file "/root/.ssh/config" do
  source "ssh_config"
  mode "0600"
  owner "root"
  group "root"
end

cookbook_file "/home/deploy/.ssh/config" do
  source "ssh_config_deploy"
  mode "0600"
  owner "deploy"
  group "apache"
end


directory "/www/connection" do
  owner "deploy"
  group "apache"
  mode 00755
  action :create
end

directory "/www/connection/releases" do
  owner "deploy"
  group "apache"
  mode 0755
  action :create
end

directory "/www/connection/shared" do
  owner "deploy"
  group "apache"
  mode 00755
  action :create
end

directory "/www/connection/shared/application/configs" do
  owner "deploy"
  group "apache"
  recursive true
  mode 00555
  action :create
end

aws_s3_file "/www/connection/shared/application/configs/config.ini" do
  bucket "keboola-configs"
  remote_path "connection/config.ini"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
  owner "deploy"
  group "apache"
  mode "0555"
end

time = Time.now.to_i

git "/www/connection/releases/#{time}" do
   repository "git@github.com:keboola/connection.git"
   revision "production"
   action :sync
   user "root"
   group "root"
end



execute "build connection" do
  cwd "/www/connection/releases/#{time}"
  command "ant update"
end

execute "create revision file" do
  cwd "/www/connection/releases/#{time}"
  command "git rev-parse HEAD > REVISION"
end

execute "chown-data-www" do
  command "chown -R deploy:apache /www/connection/releases/#{time}"
  action :run
end

directory "/www/connection/releases/#{time}/cache" do
	mode "0775"
end

directory "/www/connection/releases/#{time}/public/captcha" do
	mode "0775"
end

link "/www/connection/releases/#{time}/application/configs/config.ini" do
  to "/www/connection/shared/application/configs/config.ini"
  user "deploy"
  group "apache"
end

link "/www/connection/current" do
  to "/www/connection/releases/#{time}"
  owner "deploy"
  group "apache"
end

web_app "#{node['fqdn']}" do
  template "connection.keboola.com.conf.erb"
  server_name node['fqdn']
  server_aliases [node['hostname'], 'connection.keboola.com']
  enable true
end

template "/etc/init/connection.queue-receive.conf" do
  source 'connection.queue-receive.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

include_recipe "keboola-connection::workers"
include_recipe "keboola-connection::cron"

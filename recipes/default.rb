#
# Cookbook Name:: keboola-connection
# Recipe:: default
#


include_recipe "aws"
include_recipe "keboola-connection::php"
include_recipe "keboola-connection::apache"
include_recipe "keboola-common"

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


directory "/www/connection" do
  owner "root"
  group "root"
  mode 00555
  action :create
end


directory "/www/connection/releases" do
  owner "root"
  group "root"
  mode 00555
  action :create
end

directory "/www/connection/shared" do
  owner "root"
  group "root"
  mode 00555
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

execute "chown-data-www" do
  command "chown -R deploy:apache /www/connection/releases/#{time}"
  action :run
end

directory "/www/connection/releases/#{time}/cache" do
	mode "0775"
end

link "/www/connection/releases/#{time}/application/configs/config.ini" do
  to "/www/connection/shared/application/configs/config.ini"
  user "deploy"
  group "apache"
end

link "/www/connection/current" do
  to "/www/connection/releases/#{time}"
  user "deploy"
  group "apache"
end

web_app "#{node['fqdn']}" do
  template "connection.keboola.com.conf.erb"
  server_name node['fqdn']
  server_aliases [node['hostname'], 'connection.keboola.com']
  enable true
end
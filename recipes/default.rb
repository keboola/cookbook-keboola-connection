#
# Cookbook Name:: keboola-connection
# Recipe:: default
#


include_recipe "aws"
include_recipe "keboola-connection::php"
include_recipe "keboola-connection::apache"
include_recipe "keboola-common"

package "ant"


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

execute "chown-data-www" do
  command "chown -R deploy:apache /www/connection/releases/#{time}"
  action :run
end

execute "build connection" do
  cwd "/www/connection/releases/#{time}"
  command "ant update"
  user "deploy"
end

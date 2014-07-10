#
# Cookbook Name:: keboola-connection
# Recipe:: default
#

user "deploy" do
  gid "apache"
  home "/home/deploy"
  shell "/bin/bash"
end

remote_file "/home/ec2-user/.ssh/authorized_keys" do
	source "https://s3.amazonaws.com/keboola-configs/servers/devel_ssh_public_keys.txt"
  only_if { File.directory?("/home/ec2-user") }
end

directory "/home/deploy/.ssh" do
  owner "deploy"
  group "apache"
  mode 0700
  action :create
end

remote_file "/home/deploy/.ssh/authorized_keys" do
  owner "deploy"
  group "apache"
  mode 0700
  source "https://s3.amazonaws.com/keboola-configs/servers/devel_ssh_public_keys.txt"
end


include_recipe "aws"
include_recipe "keboola-common"
include_recipe "php"
include_recipe "keboola-connection::apache"


directory "/www/connection" do
  owner "root"
  group "root"
  mode 00555
  action :create
end

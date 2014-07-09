#
# Cookbook Name:: keboola-connection
# Recipe:: default
#


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

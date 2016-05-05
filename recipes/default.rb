#
# Cookbook Name:: keboola-connection
# Recipe:: default
#


include_recipe "keboola-common"
include_recipe "keboola-php56"
include_recipe "keboola-apache2"
include_recipe 'sysctl::apply'

if node['keboola-connection']['enable_newrelic_apm'].to_i > 0
  include_recipe "newrelic::php_agent"
end


# ssl certificates for KBC
execute "download certificates" do
  command "aws s3 cp s3://keboola-configs/certificates/keboola-connection-certificates.tar.gz /tmp/keboola-connection-certificates.tar.gz"
end

directory "#{node['apache']['dir']}/ssl" do
  owner "root"
  group "root"
  mode 00644
  action :create
end

execute "extract-certificates" do
  command "tar --strip 1 -C #{node['apache']['dir']}/ssl -xf  /tmp/keboola-connection-certificates.tar.gz"
  user "root"
  group "root"
end

file "/tmp/keboola-connection-certificates.tar.gz" do
  action :delete
end

# required for mysql exports using command line
package "mysql-common"
package "mysql55"

# fixed yum install php54-pgsql
package "postgresql9"


# snowflake

#odbc support for php 5.6
execute "install unixodbc" do
  command "yum -y install unixODBC.x86_64"
end

execute "install php56-odbc" do
  command "yum -y install php56-odbc php56-odbc.x86_64"
end

execute "download snowflake drivers" do
  command "aws s3 cp s3://keboola-configs/connection/snowflake_linux_x8664_odbc.tgz /tmp/snowflake_linux_x8664_odbc.tgz"
end

execute "unpack snowflake driver" do
  command "gunzip /tmp/snowflake_linux_x8664_odbc.tgz"
end

execute "untar snowflake driver" do
  command "cd /tmp && tar -xvf snowflake_linux_x8664_odbc.tar"
end

execute "move snowflake driver" do
  command "mv /tmp/snowflake_odbc /usr/bin/snowflake_odbc"
end

cookbook_file "/etc/odbcinst.ini" do
  source "odbcinst.ini"
  mode "0644"
  owner "root"
  group "root"
end

cookbook_file "/etc/simba.snowflake.ini" do
  source "simba.snowflake.ini"
  mode "06444"
  owner "root"
  group "root"
end

## snowflake end

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



time = Time.now.to_i

directory "/www/connection/releases/#{time}" do
  owner "deploy"
  group "apache"
  recursive true
  mode 00555
  action :create
end



execute "download connection from s3" do
  command "aws s3 cp s3://keboola-builds/connection/connection.tar.gz /tmp/connection.tar.gz"
end

execute "extract-connection-app" do
  command "tar -C /www/connection/releases/#{time} -xf  /tmp/connection.tar.gz"
end

file "/tmp/connection.tar.gz" do
  action :delete
end


execute "download config from s3" do
  command "aws s3 cp s3://keboola-configs/connection/config.ini /www/connection/releases/#{time}/application/configs/config.ini"
end

execute "chown-data-www" do
  command "chown -R deploy:apache /www/connection/releases/#{time}"
  action :run
end

directory "/www/connection/releases/#{time}/cache" do
	mode "0775"
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

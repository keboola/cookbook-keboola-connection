

include_recipe "php"

php_pear "zendopcache" do
  action :install
  version "7.0.3"
end


template "#{node['php']['ext_conf_dir']}/zendopcache.ini" do
  source 'opcache.ini.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables({
      :ext_dir => '/usr/lib64/php/modules'
    })
  if node['recipes'].include?('php::fpm')
    notifies :restart, "service[#{svc}]"
  end
end


template "#{node['php']['ext_conf_dir']}/apc.ini" do
  source 'apc.ini.erb'
  owner 'root'
  group 'root'
  mode 00644
end
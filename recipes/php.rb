

include_recipe "php"

php_pear "zendopcache" do
  action :install
  version "7.0.3"
end

# We install the PHP packages at compile time in order to have the php-config executable available for query
ext_dir = `php-config --extension-dir`.chomp
ext_dir.empty? && raise('Could not execute php-config to locate the PHP extension dir. Please install the PHP development libraries')
Chef::Log.info("Discovered PHP extension dir to be #{ext_dir}")

template "#{node['php']['ext_conf_dir']}/zendopcache.ini" do
  source 'opcache.ini.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables({
      :ext_dir => ext_dir
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
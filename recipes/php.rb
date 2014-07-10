

include_recipe "php"

template "#{node['php']['ext_conf_dir']}/opcache.ini" do
  source 'opcache.ini.erb'
  owner 'root'
  group 'root'
  mode 00644
  if node['recipes'].include?('php::fpm')
    notifies :restart, "service[#{svc}]"
  end
end

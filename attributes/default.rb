

default['keboola-connection']['workers']['eventsElastic'] = 0
default['keboola-connection']['workers']['main'] = 0
default['keboola-connection']['workers']['main_fast'] = 0

default['keboola-connection']['syrup_url'] = ''

default['keboola-connection']['enable_cron'] = false
default['keboola-connection']['enable_newrelic_apm'] = false

default['aws']['aws_access_key_id'] = ''
default['aws']['aws_secret_access_key'] = ''


default['php']['packages'] = %w{ php56 php56-opcache php56-devel php56-gd php-pear php56-pdo php56-mysqlnd php56-pgsql php56-mcrypt }

default['php']['directives'] = {
    'date.timezone' => 'Europe/Prague',
    'always_populate_raw_post_data' => '-1',
    'memory_limit' => '512M'
}

default['newrelic']['php_agent']['config_file'] = "/etc/php-5.6.d/newrelic.ini"

default['sysctl']['params']['vm']['vfs_cache_pressure'] = 10000

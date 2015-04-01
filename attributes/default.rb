

default['keboola-connection']['workers']['eventsElastic'] = 0
default['keboola-connection']['workers']['main'] = 0
default['keboola-connection']['workers']['main_fast'] = 0

default['keboola-connection']['enable_cron'] = false

default['aws']['aws_access_key_id'] = ''
default['aws']['aws_secret_access_key'] = ''


default['php']['packages'] = %w{ php56 php56-opcache php56-devel php56-gd php-pear php56-pdo php56-mysqlnd php56-pgsql php56-mcrypt }


default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '0.10.26'
default['nodejs']['checksum_linux_x64'] = '305bf2983c65edea6dd2c9f3669b956251af03523d31cf0a0471504fd5920aac'
default['nodejs']['checksum_linux_x86'] = '8fa2d952556c8b5aa37c077e2735c972c522510facaa4df76d4244be88f4dc0f'
default['nodejs']['checksum_linux_arm-pi'] = '561ec2ebfe963be8d6129f82a7d1bc112fb8fbfc0a1323ebe38ef55850f25517'
default['nodejs']['dir'] = '/usr'

default['newrelic']['php_agent']['config_file'] = "/etc/php.d/newrelic.ini"

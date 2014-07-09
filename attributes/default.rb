

default['aws']['aws_access_key_id'] = ''
default['aws']['aws_secret_access_key'] = ''

default['postfix']['main']['smtp_sasl_password_maps'] = 'static:'


default['apache']['user'] = 'apache'
default['apache']['package'] = 'httpd24'
default['apache']['default_modules'] = %w[
  logio auth_basic authn_file authz_groupfile authz_host authz_user
  dir env mime negotiation setenvif
]

default['php']['packages'] = %w{ php55 php-pear } 


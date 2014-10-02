name             'keboola-connection'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures syrup'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends 'aws', '~> 2.4.0'
depends 'apache2', '~> 2.0.0'
depends 'php', '~> 1.4.6'
depends 'keboola-common'
depends 'nodejs', '~> 2.1.0'
name             'papertrail'
maintainer       'Papertrail'
maintainer_email 'support@beanbaginc.com'
license          'MIT'
description      'Installs/Configures Papertrail\'s remote_syslog2'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/papertrail/chef-papertrail'
version          '1.2'
issues_url       'https://github.com/papertrail/chef-papertrail/issues'
chef_version     '>= 12.21'
supports 'ubuntu', '>= 14.04'
supports 'debian', '>= 9.0'
supports 'centos', '>= 6.0'
supports 'redhat', '>= 6.0'
supports 'amazon', '= 2017.03'

depends 'yum'
depends 'yum-epel'
depends 'apt'

# @summary
#  Creates an instanciated instance of honeytail using the provided configuration
#
# @example
#   honeytail::instance {'mysql':
#     config => {
#       'Required Options' => {
#         'ParserName' => 'mysql',
#         'WriteKey'   => 'REDACTED',
#         'LogFiles'   => '/var/lib/mysql/slow-query.log',
#         'Dataset'    => 'mysql'
#       }
#     }
#   }
#
#  @param config
#    The configuration to pass to honeytail. Honeytail uses ini format for it's configuration,
#    please refer to examples, honeytail docs and puppetlabs-inifile module docs.
#
#  @param ensure
#    Whether the instanciated honeytail service should be running. Default value: 'running'
#
#  @param enable
#    Whether to enable the instanciated honeytail service at boot. Default value: true.
#
define honeytail::instance (
  Hash $config,
  Enum['running', 'stopped'] $ensure = running,
  Boolean $enable = true,
) {
  # core
  include ::honeytail

  $settings = {
    'header'            => "# This file is managed by puppet (${module_name})",
    'key_val_separator' => ' = ',
    'quote_char'        => '',
  }

  file {"/etc/honeytail/conf.d/${name}.conf":
    ensure  => 'present',
    content => hash2ini($config, $settings),
    before  => "Service[honeytail@${name}]",
    require => 'File[/etc/honeytail/conf.d/]'
  }

  # service
  service {"honeytail@${name}":
    ensure  => $ensure,
    enable  => $enable,
    require => 'Systemd::Unit_file[honeytail@.service]'
  }
}

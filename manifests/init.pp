# @summary
#   This module installs, configures and manages Honeycomb.io's honeytail
#
# @example
#   class {'honeytail':
#     direct_download => 'https://honeycomb.io/download/honeytail/linux/honeytail-1.762-1.x86_64.rpm'
#   }
#
class honeytail (
  String $version = 'installed',
  Optional[String] $direct_download = undef
){
  contain honeytail::package
  contain honeytail::config
  contain honeytail::service

  Class['::honeytail::package']
  -> Class['::honeytail::config']
  -> Class['::honeytail::service']
}

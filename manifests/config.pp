# @summary
#   This class handles the configuration.
#
# @api private
#
class honeytail::config {

  file {'/etc/honeytail/conf.d/':
    ensure  => directory,
    require => Package['honeytail'],
    purge   => true,
    recurse => true
  }
}

# @summary
#   This class handles installing the honeytail package
#
# @api private
#
class honeytail::package {

  if $honeytail::direct_download {
    # directory for temp files
    file {'/var/cache/honeytail_pkgs':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    # equivalent to basename() - get the filename
    $package_file = regsubst($honeytail::direct_download, '(.*?)([^/]+)$', '\2')
    $local_file = "/var/cache/honeytail_pkgs/${package_file}"

    if $honeytail::version != 'absent' {
      # make download optional if we are removing...
      archive { $package_file:
        source  => $honeytail::direct_download,
        path    => $local_file,
        cleanup => false,
        extract => false,
        before  => Package[honeytail],
      }
    }

    $package_provider = $facts['os']['family'] ? {
      'RedHat' => 'rpm',
      'Debian' => 'dpkg',
      default  => warning("This module does not support: ${facts['os']['family']}")
    }

    package {'honeytail':
      ensure   => $honeytail::version,
      provider => $package_provider,
      source   => $local_file
    }

  } else {

    package {'honeytail':
      ensure => $honeytail::version,
    }

  }
}

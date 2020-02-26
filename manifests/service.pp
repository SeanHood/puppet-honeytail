# @summary
#   This class creates our systemd mess
#
# @api private
#
class honeytail::service {

  systemd::unit_file { 'honeytail@.service':
    source => "puppet:///modules/${module_name}/honeytail@.service",
  }

}

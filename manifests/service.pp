# == Definition: fcrepo::service
#
# Sets the Tomcat/Fedora service for starup
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
#
define fcrepo::service (
  $service_name   = 'tomcat-fcrepo',
  $service_enable = false,
  $service_ensure = 'stopped',
) {

  include fcrepo

  tomcat::service { 'tomcat-fcrepo':
    catalina_base  => $::fcrepo::tomcat_deploydir_real,
    service_name   => $service_name,
    service_enable => $service_enable,
    service_ensure => $service_ensure,
    user           => $::fcrepo::user_real,
  }
}

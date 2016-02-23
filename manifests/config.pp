# == Class: fcrepo::config
#
# Install the configuration files for Tomcat and Fedora.
# Parameters are set in class fcrepo
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Scott Prater <sprater@gmail.com>
#
# === Copyright
#
# Copyright 2014 Scott Prater
#
class fcrepo::config {

  include fcrepo

  # Create the config directory
  file { $::fcrepo::fcrepo_configdir_real:
    ensure  => directory,
    path    => $::fcrepo::fcrepo_configdir_real,
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ File[$::fcrepo::fcrepo_sandbox_home_real] ]
  }
# 
#   # Put in place Tomcat server.xml
#   file { "${::fcrepo::tomcat_deploydir_real}/conf/server.xml":
#     ensure  => file,
#     path    => "${::fcrepo::tomcat_deploydir_real}/conf/server.xml",
#     group   => $::fcrepo::group_real,
#     owner   => $::fcrepo::user_real,
#     mode    => '0600',
#     content => template('fcrepo/server.xml.erb'),
#   }
# 
#   # Put in place Tomcat setenv.sh
#   file { "${::fcrepo::tomcat_deploydir_real}/bin/setenv.sh":
#     ensure  => file,
#     path    => "${::fcrepo::tomcat_deploydir_real}/bin/setenv.sh",
#     group   => $::fcrepo::group_real,
#     owner   => $::fcrepo::user_real,
#     mode    => '0755',
#     content => template('fcrepo/setenv.sh.erb'),
#   }

  # Put in place Fedora config repository.json
  file { "${::fcrepo::fcrepo_configdir_real}/repository.json":
    ensure  => file,
    path    => "${::fcrepo::fcrepo_configdir_real}/repository.json",
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0644',
    content => template("fcrepo/${::fcrepo::fcrepo_configtype_real}/repository.json.erb"),
    require => File[$::fcrepo::fcrepo_configdir_real],
  }

  # Put in place Fedora config jgroups-fcrepo-tcp.xml
  file { "${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml":
    ensure  => file,
    path    => "${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml",
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0644',
    content => template("fcrepo/${::fcrepo::fcrepo_configtype_real}/jgroups-fcrepo-tcp.xml.erb"),
    require => File[$::fcrepo::fcrepo_configdir_real],
  }

  # Put in place Fedora config infinispan.xml
  file { "${::fcrepo::fcrepo_configdir_real}/infinispan.xml":
    ensure  => file,
    path    => "${::fcrepo::fcrepo_configdir_real}/infinispan.xml",
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0644',
    content => template("fcrepo/${::fcrepo::fcrepo_configtype_real}/infinispan.xml.erb"),
    require => File[$::fcrepo::fcrepo_configdir_real],
  }

  Class['fcrepo::install'] ~> Class['fcrepo::config']
}

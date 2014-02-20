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
  service { "tomcat7":
    ensure  => "running",
    enable  => "true",
  }

  # Create the config directory
  file { $::fcrepo::fcrepo_configdir_real:
    ensure  => directory,
    path    => $::fcrepo::fcrepo_configdir_real,
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ File[$::fcrepo::fcrepo_sandbox_home_real] ]
  }

  # Put in place Tomcat server.xml
  file { "${::fcrepo::tomcat_configs_real}/server.xml":
    ensure  => file,
    path    => "${::fcrepo::tomcat_configs_real}/server.xml",
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0600',
    content => template('fcrepo/server.xml.erb'),
    notify  => Service["tomcat7"]
  }

  # Put in place Tomcat setenv.sh
  file { "${::fcrepo::tomcat_runtimes_real}/bin/setenv.sh":
    ensure  => file,
    path    => "${::fcrepo::tomcat_runtimes_real}/bin/setenv.sh",
    group   => "root",
    owner   => "root",
    mode    => '0755',
    content => template('fcrepo/setenv.sh.erb'),
    notify  => Service["tomcat7"]
  }

  # Put in place Fedora config repository.json
  file { "${::fcrepo::fcrepo_configdir_real}/repository.json":
    ensure  => file,
    path    => "${::fcrepo::fcrepo_configdir_real}/repository.json",
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0644',
    content => template('fcrepo/repository.json.erb'),
    require => File[$::fcrepo::fcrepo_configdir_real],
    notify  => Service["tomcat7"]
  }

  # Put in place Fedora config jgroups-fcrepo-tcp.xml
  file { "${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml":
    ensure  => file,
    path    => "${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml",
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0644',
    content => template('fcrepo/jgroups-fcrepo-tcp.xml.erb'),
    require => File[$::fcrepo::fcrepo_configdir_real],
    notify  => Service["tomcat7"]
  }

  # Put in place Fedora config infinispan.xml
  file { "${::fcrepo::fcrepo_configdir_real}/infinispan.xml":
    ensure  => file,
    path    => "${::fcrepo::fcrepo_configdir_real}/infinispan.xml",
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0644',
    content => template('fcrepo/infinispan.xml.erb'),
    require => File[$::fcrepo::fcrepo_configdir_real],
    notify  => Service["tomcat7"]
  }

  Class['fcrepo::install'] ~> Class['fcrepo::config']
}

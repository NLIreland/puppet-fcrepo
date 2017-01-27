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

  # Put in place Fedora config repository.json
  # It would be easier to use file for these, but file won't support https URLs until 
  # Puppet 4.4
  staging::file { 'repository.json':
    target  => "${::fcrepo::fcrepo_configdir_real}/repository.json",
    source  => $::fcrepo::fcrepo_repository_json_real,
    require => File[$::fcrepo::fcrepo_configdir_real],
  }->
  file { "${::fcrepo::fcrepo_configdir_real}/repository.json":
    ensure => present,
    group  => $::fcrepo::group_real,
    owner  => $::fcrepo::user_real,
    mode   => '0644',
  }->
  exec { 'replace infinispan config path':
    command     => "/bin/sed -i -e's|\\$.fcrepo.ispn.configuration:config.*infinispan.xml.|${::fcrepo::fcrepo_configdir_real}/infinispan.xml|' '${::fcrepo::fcrepo_configdir_real}/repository.json'",
    path        => '/bin',
    subscribe   => File["${::fcrepo::fcrepo_configdir_real}/repository.json"],
    refreshonly => true,
  }
  
  # Put in place Fedora config jgroups-fcrepo-tcp.xml
  staging::file { 'jgroups-fcrepo-tcp.xml':
    target  => "${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml",
    source  => $::fcrepo::fcrepo_jgroups_fcrepo_tcp_xml_real,
    require => File[$::fcrepo::fcrepo_configdir_real],
  }->
  file { "${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml":
    ensure => present,
    group  => $::fcrepo::group_real,
    owner  => $::fcrepo::user_real,
    mode   => '0644',
  }
  
  # Put in place Fedora config infinispan.xml
  staging::file { 'infinispan.xml':
    target  => "${::fcrepo::fcrepo_configdir_real}/infinispan.xml",
    source  => $::fcrepo::fcrepo_infinispan_xml_real,
    require => File[$::fcrepo::fcrepo_configdir_real],
  }->
  file { "${::fcrepo::fcrepo_configdir_real}/infinispan.xml":
    ensure => present,
    group  => $::fcrepo::group_real,
    owner  => $::fcrepo::user_real,
    mode   => '0644',
  }

  # Fedora cycle server
  # Create directory for cron logging and cron's for powering on and off Fedora

  file {'cron_log_directory':
    ensure => 'directory',
    path   => "{$::fcrepo::fcrepo_sandbox_home_real}/cron_logs",
    group  => $::fcrepo::group_real,
    owner  => $::fcrepo::user_real,
    mode   => '0755',
  }
  cron {'shutdown_fedora':
    command => "$tomcat_deploydir/bin/shutdown.sh > {$::fcrepo::fcrepo_sandbox_home_real}/cron_logs/cycle_tomcat_log.log 2>&1",
    user    => $::fcrepo::user_real,
    hour    => '10',
    minute  => '15',
    require => [File['cron_log_directory'], File["{$tomcat_deploydir/bin/shutdown.sh}"]],
  }
  cron {'startup_fedora':
    command => "$tomcat_deploydir/bin/startup.sh > {$::fcrepo::fcrepo_sandbox_home_real}/cron_logs/cycle_tomcat_log.log 2>&1",
    user    => $::fcrepo::user_real,
    hour    => '10',
    minute  => '17',
    require => [File['cron_log_directory'], File["{$tomcat_deploydir/bin/startup.sh}"]],
  }

  Class['fcrepo::install'] ~> Class['fcrepo::config']
}

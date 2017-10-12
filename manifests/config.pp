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
  #staging::file { 'repository.json':
  #  target  => "${::fcrepo::fcrepo_configdir_real}/repository.json",
  #  source  => $::fcrepo::fcrepo_repository_json_real,
  #  require => File[$::fcrepo::fcrepo_configdir_real],
  #}->
  #file { "${::fcrepo::fcrepo_configdir_real}/repository.json":
  #  ensure => present,
  #  group  => $::fcrepo::group_real,
  #  owner  => $::fcrepo::user_real,
  #  mode   => '0644',
  #}->
  #exec { 'replace infinispan config path':
  #command     => "/bin/sed -i -e's|\\$.fcrepo.ispn.configuration:config.*infinispan.xml.|${::fcrepo::fcrepo_configdir_real}/infinispan.xml|' '${::fcrepo::fcrepo_configdir_real}/repository.json'",
  #  path        => '/bin',
  #  subscribe   => File["${::fcrepo::fcrepo_configdir_real}/repository.json"],
  #  refreshonly => true,
  #}
  
  # Put in place Fedora config jgroups-fcrepo-tcp.xml
  #staging::file { 'jgroups-fcrepo-tcp.xml':
  #  target  => "${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml",
  #  source  => $::fcrepo::fcrepo_jgroups_fcrepo_tcp_xml_real,
  #  require => File[$::fcrepo::fcrepo_configdir_real],
  #}->
  #file { "${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml":
  #  ensure => present,
  #  group  => $::fcrepo::group_real,
  #  owner  => $::fcrepo::user_real,
  #  mode   => '0644',
  #}
  
  # Put in place Fedora config infinispan.xml
  #staging::file { 'infinispan.xml':
  #  target  => "${::fcrepo::fcrepo_configdir_real}/infinispan.xml",
  #  source  => $::fcrepo::fcrepo_infinispan_xml_real,
  #  require => File[$::fcrepo::fcrepo_configdir_real],
  #}->
  #file { "${::fcrepo::fcrepo_configdir_real}/infinispan.xml":
  #  ensure => present,
  #  group  => $::fcrepo::group_real,
  #  owner  => $::fcrepo::user_real,
  #  mode   => '0644',
  #}

  # Fedora cycle server
  # Create directory for cron logging and cron's for powering on and off Fedora

  if $::fcrepo::fcrepo_cycle_server_required == true {

    file {$fcrepo::params::fcrepo_cycle_server:
      ensure => 'present',
      owner => 'root',
      group => 'root',
      mode => '0755',
      content => template('fcrepo/cycle_fedora.sh.erb'),
    }
    file { $fcrepo::params::fcrepo_cron_log_dir:
      ensure  => 'directory',
      group   => $::fcrepo::group_real,
      owner   => $::fcrepo::user_real,
      mode    => '0755',
      require => File[$fcrepo::params::fcrepo_cycle_server],
    }
    cron {'shutdown_fedora':
      command => "sh $fcrepo::params::fcrepo_cycle_server stop",
      user    => root,
      hour    => '5',
      minute  => '4',
      require => File[$fcrepo::params::fcrepo_cron_log_dir],
    }
    cron {'startup_fedora':
      command => "sh $fcrepo::params::fcrepo_cycle_server start",
      user    => root,
      hour    => '5',
      minute  => '7',
      require => File[$fcrepo::params::fcrepo_cron_log_dir],
    }
  }

  Class['fcrepo::install'] ~> Class['fcrepo::config']
}

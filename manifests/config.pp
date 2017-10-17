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
  include wget

  # Create the config directory
  file { $::fcrepo::fcrepo_configdir_real:
    ensure  => directory,
    path    => $::fcrepo::fcrepo_configdir_real,
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ File[$::fcrepo::fcrepo_sandbox_home_real] ],
  }

  # Put in place Fedora config repository.json
  # It would be easier to use file for these, but file won't support https URLs until 
  # Puppet 4.4
  wget::fetch { "get jgroups-fcrepo-tcp.xm":
    source      => "${::fcrepo::fcrepo_jgroups_fcrepo_tcp_xml}",
    destination => '/tmp/jgroups-fcrepo-tcp.xml',
    timeout     => 0,
    verbose     => false,
  }->
  wget::fetch { 'get repository.json':
    source => "${::fcrepo::fcrepo_jgroups_fcrepo_tcp_xml}",
    destination => '/tmp/repository.json',
    timeout     => 0,
    verbose     => false,
  }->
  # Put in place Fedora config jgroups-fcrepo-tcp.xml
  file { "${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml":
    source => "/tmp/jgroups-fcrepo-tcp.xml",
    #target => "${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml",
    ensure => present,
    group  => $::fcrepo::group_real,
    owner  => $::fcrepo::user_real,
    mode   => '0644',
  }->
  # Put in place Fedora config repository.json
  file { "${::fcrepo::fcrepo_configdir_real}/infinispan.xml":
    source => "/tmp/repository.json",
    #target => "${::fcrepo::fcrepo_configdir_real}/repository.json",
    ensure => present,
    group  => $::fcrepo::group_real,
    owner  => $::fcrepo::user_real,
    mode   => '0644',
  }

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

# == Class: fcrepo::install
#
# Install the packages and software necessary to run Fedora
# Parameters are set in class fcrepo
#
# === Parameters
#
# [*user_real*]
#   The Unix user to configure and install Fedora 4 and supporting applications.
#
# [*group_real*]
#   The Unix group to configure and install Fedora 4 and supporting
#   applications.
#
# [*fcrepo_sandbox_home_real*]
#   The base directory for the Fedora 4 sandbox.
#
# [*fcrepo_datadir_real*]
#   The Fedora 4 data directory.
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
class fcrepo::install {

  include fcrepo

  #  Create the user and group
  group { $::fcrepo::group_real:
    ensure => present,
  }

  user { $::fcrepo::user_real:
    ensure  => present,
    gid     => $::fcrepo::group_real,
    shell   => '/bin/bash',
    require => Group[$::fcrepo::group_real],
  }

  # Create the sandbox directory and data directory
  file { $::fcrepo::fcrepo_sandbox_home_real:
    ensure  => directory,
    path    => $::fcrepo::fcrepo_sandbox_home_real,
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ Group[$::fcrepo::group_real], User[$::fcrepo::group_real] ]
  }

  file { $::fcrepo::fcrepo_datadir_real:
    ensure  => directory,
    path    => $::fcrepo::fcrepo_datadir_real,
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ Group[$::fcrepo::group_real], User[$::fcrepo::group_real] ]
  }

}

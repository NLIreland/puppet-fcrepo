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
# [*user_profile_real*]
#   The profile file to be modified with updated PATH entries, other
#   environment variables.
#
# [*fcrepo_sandbox_home_real*]
#   The base directory for the Fedora 4 sandbox.
#
# [*fcrepo_datadir_real*]
#   The Fedora 4 data directory.
#
# [*java_source_real*]
#   The Java source file.
#
# [*java_deploydir_real*]
#   The Java base directory (JAVA_HOME).
#
# [*maven_source_real*]
#   The Maven source file.
#
# [*maven_deploydir_real*]
#   The Maven base directory.
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
    ensure     => present,
    gid        => $::fcrepo::group_real,
    shell      => '/bin/bash',
    home       => "/home/${::fcrepo::user_real}",
    managehome => true,
    require    => Group[$::fcrepo::group_real],
  }

  # Create the sandbox directory, data directory,
  # user home directory, and user profile
  file { $::fcrepo::fcrepo_sandbox_home_real:
    ensure  => directory,
    path    => $::fcrepo::fcrepo_sandbox_home_real,
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ Group[$::fcrepo::group_real], User[$::fcrepo::user_real] ]
  }

  file { $::fcrepo::fcrepo_datadir_real:
    ensure  => directory,
    path    => $::fcrepo::fcrepo_datadir_real,
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ Group[$::fcrepo::group_real], User[$::fcrepo::user_real] ]
  }

  file { "/home/${::fcrepo::user_real}":
    ensure  => directory,
    path    => "/home/${::fcrepo::user_real}",
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ Group[$::fcrepo::group_real], User[$::fcrepo::user_real] ]
  }

  file { $::fcrepo::user_profile_real:
    ensure  => file,
    path    => $::fcrepo::user_profile_real,
  }

  # Install the infrastructure software

  # Java
  java::setup { $::fcrepo::java_source_real:
    ensure        => 'present',
    source        => $::fcrepo::java_source_real,
    deploymentdir => $::fcrepo::java_deploydir_real,
    user          => $::fcrepo::user_real,
    pathfile      => $::fcrepo::user_profile_real,
  }

  # Maven
  java::setup { $::fcrepo::maven_source_real:
    ensure        => 'present',
    source        => $::fcrepo::maven_source_real,
    deploymentdir => $::fcrepo::maven_deploydir_real,
    user          => $::fcrepo::user_real,
    pathfile      => $::fcrepo::user_profile_real,
  }

}

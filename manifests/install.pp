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
# [*java_homedir_real*]
#   The directory with the Java installation (JAVA_HOME).
#
# [*tomcat_source_real*]
#   The Tomcat source file.
#
# [*tomcat_deploydir_real*]
#   The Tomcat base directory (CATALINA_HOME).
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
    content => "export JAVA_HOME=${::fcrepo::java_homedir_real}",
    path    => $::fcrepo::user_profile_real,
  }

  # Install the infrastructure software

# 
#   # Tomcat
#   tomcat::install { $::fcrepo::tomcat_source_real:
#     source                     => $::fcrepo::tomcat_source_real,
#     deploymentdir              => $::fcrepo::tomcat_deploydir_real,
#     user                       => $::fcrepo::user_real,
#     group                      => $::fcrepo::group_real,
#     default_webapp_docs        => 'absent',
#     default_webapp_examples    => 'absent',
#     default_webapp_hostmanager => 'absent',
#     default_webapp_manager     => 'absent',
#     default_webapp_root        => 'absent',
#     require                    => [ File[$::fcrepo::fcrepo_sandbox_home_real] ]
#   }

  # Tomcat
  tomcat::instance { 'tomcat-fcrepo':
    user          => $fcrepo::params::user_real,
    group         => $fcrepo::params::group_real,
    catalina_base       => $::fcrepo::tomcat_deploydir_real,
    install_from_source => true,
    package_name        => 'tomcat',
    source_url          => $::fcrepo::tomcat_source_real,
  }->
  tomcat::config::server { 'tomcat-fcrepo':
    catalina_base => $::fcrepo::tomcat_deploydir_real,
    port          => '8105',
  }->
  tomcat::config::server::connector { 'tomcat-fcrepo-http':
    catalina_base         => $::fcrepo::tomcat_deploydir_real,
    port                  => $::fcrepo::tomcat_http_port_real,
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => $::fcrepo::tomcat_redirect_port_real,
    },
  }


  # Fedora 4 WAR
  file { "${::fcrepo::tomcat_deploydir_real}/webapps/fcrepo.war":
    ensure  => 'file',
    path    => "${::fcrepo::tomcat_deploydir_real}/webapps/fcrepo.war",
    source  => 'puppet:///modules/fcrepo/fcrepo.war',
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0644',
    require => [ Tomcat::Install[$::fcrepo::tomcat_source_real] ]
  }

}

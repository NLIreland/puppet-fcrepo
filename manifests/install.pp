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
  # Note: user and group can't yet be set reliably without an update to the puppetlabs/tomcat
  # code. It looks like this change is in Master, waiting for release 1.4.2 which should
  # solve this issue.
 tomcat::instance { 'tomcat-fcrepo':
#    user                => $::fcrepo::user_real,
#    group               => $::fcrepo::group_real,
    catalina_base       => $::fcrepo::tomcat_deploydir_real,
#    catalina_home       => $::fcrepo::tomcat_deploydir_real,
    install_from_source => $::fcrepo::tomcat_install_from_source_real,
    package_name        => 'tomcat',
    source_url          => $::fcrepo::tomcat_source_real,
  }->
  tomcat::config::server { 'tomcat-fcrepo':
    catalina_base       => $::fcrepo::tomcat_deploydir_real,
    port                => '8105',
  }->
  tomcat::config::server::connector { 'tomcat-fcrepo-http':
    catalina_base         => $::fcrepo::tomcat_deploydir_real,
    port                  => $::fcrepo::tomcat_http_port_real,
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => $::fcrepo::tomcat_redirect_port_real,
    }
  }->
  tomcat::config::server::connector { 'tomcat-fcrepo-ajp':
    catalina_base         => $::fcrepo::tomcat_deploydir_real,
    port                  => $::fcrepo::tomcat_ajp_port_real,
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => $::fcrepo::tomcat_redirect_port_real,
    }
  }->
  tomcat::config::server::host { 'tomcat-fcrepo-host':
    catalina_base         => $::fcrepo::tomcat_deploydir_real,
    host_name             => $::hostname,
    app_base              => 'webapps',
  }->
  tomcat::war { 'fcrepo.war':
    catalina_base => $::fcrepo::tomcat_deploydir_real,
    app_base      => 'webapps',
    war_source    => $::fcrepo::fcrepo_warsource_real,
  }->
  tomcat::setenv::entry {'tomcat-fcrepo-catalina-opts':
    config_file => "${::fcrepo::tomcat_deploydir_real}/bin/setenv.sh",
    param => 'CATALINA_OPTS',
    value => "-Xmx1024m -XX:MaxPermSize=256m -Djava.net.preferIPv4Stack=true -Djgroups.udp.mcast_addr=239.42.42.42 -Dfcrepo.modeshape.configuration=file://${::fcrepo::fcrepo_configdir_real}/repository.json -Dfcrepo.ispn.jgroups.configuration=${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml -Dfcrepo.infinispan.cache_configuration=${::fcrepo::fcrepo_configdir_real}/infinispan.xml -Dfcrepo.home=${::fcrepo::fcrepo_datadir_real}/fcrepo",
    quote_char => "\"",
  }
  tomcat::setenv::entry {'tomcat-fcrepo-java-home':
    config_file => "${::fcrepo::tomcat_deploydir_real}/bin/setenv.sh",
    param => 'JAVA_HOME',
    value => "${::fcrepo::java_homedir_real}",
    quote_char => "\"",
  }

# 
#   # Fedora 4 WAR
#   file { "${::fcrepo::tomcat_deploydir_real}/webapps/fcrepo.war":
#     ensure  => 'file',
#     path    => "${::fcrepo::tomcat_deploydir_real}/webapps/fcrepo.war",
#     source  => 'puppet:///modules/fcrepo/fcrepo.war',
#     group   => $::fcrepo::group_real,
#     owner   => $::fcrepo::user_real,
#     mode    => '0644',
#     require => [ Tomcat::Install[$::fcrepo::tomcat_source_real] ]
#   }

}

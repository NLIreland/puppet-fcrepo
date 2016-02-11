# == Class: fcrepo::params
#
# Configuration parameters for the fcrepo module
#
# === Parameters
#
# [*user*]
#   The Unix user that will own and manage Fedora and its sandbox.
#
# [*group*]
#   The Unix group that will own and manage Fedora and its sandbox.
#
# [*user_profile*]
#   The shell profile file that should be modified to update the PATH,
#   set other environment variables.
#
# [*fcrepo_sandbox_home*]
#   The base directory where Fedora and its supporting infrastructure software
#   will be installed.
#
# [*fcrepo_datadir*]
#   The Fedora data directory.
#
# [*fcrepo_configdir*]
#   Fedora 4 config directory.
#
# [*fcrepo_configtype*]
#   Fedora 4 config file types (i.e., the version of Fedora that the config files
#   are used for, and whether they are for default or clustered configurations).
#
# [*java_homedir*]
#   The directory where Java has been installed (JAVA_HOME).
#
# [*tomcat_source*]
#   The Tomcat source file, under files/.
#
# [*tomcat_deploydir*]
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
class fcrepo::params {

    $user                = 'fcrepo'
    $group               = 'fcrepo'
    $user_profile        = '/home/fcrepo/.bashrc'
    $fcrepo_sandbox_home = '/fedora'
    $fcrepo_datadir      = '/data'
    $fcrepo_configdir    = '/fedora/config'
    $fcrepo_configtype   = 'fcrepo-4.4.0-minimal-default'
    $java_homedir        = '/usr/java/default'
    $tomcat_source       = 'apache-tomcat-7.0.50.tar.gz'
    $tomcat_deploydir    = '/fedora/tomcat7'
}

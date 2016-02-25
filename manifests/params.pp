# == Class: fcrepo::params
#
# Configuration parameters for the fcrepo module
#
# === Parameters
#
# [*user*]
#   Unix user that will own and manage the Fedora 4 repository directories,
#   file, and service.
#
# [*group*]
#   Unix group that will own and manage the Fedora 4 repository directories,
#   file, and service.
#
# [*user_profile*]
#   The absolute path to the user's shell profile file.  May be a system-wide
#   file.
#
# [*fcrepo_sandbox_home*]
#   The base directory where Fedora and its supporting infrastructure software
#   will be installed.
#
# [*fcrepo_datadir*]
#   Fedora 4 data directory.
#
# [*fcrepo_configdir*]
#   Fedora 4 config directory.
#
# [*fcrepo_configtype*]
#   Fedora 4 config file types (i.e., the version of Fedora that the config files
#   are used for, and whether they are for default or clustered configurations).
#
# [*fcrepo_warsource*]
#   Location where the Fedora 4 war file can be found for download and installation into
#   tomcat. Can be a string containing a puppet://, http(s)://, or ftp:// URL.
#
# [*java_homedir*]
#   The directory where Java has been installed (JAVA_HOME).
#
# [*tomcat_source*]
#   The location where the Tomcat .tar.gz source file can be found for download.
#
# [*tomcat_deploydir*]
#   The Tomcat base directory (CATALINA_HOME).
#
# [*tomcat_install_from_source*]
#   A boolean.
#   true  - means the tomcat installation will be down given the $tomcat_source file.
#   false - means that the tomcat installation will be done using the OS package.
#
# [*tomcat_http_port*]
#   The port that tomcat will be configured to listen on for http connections
#
# [*tomcat_ajp_port*]
#   The port that tomcat will be configured to listen for ajp connections
#
# [*tomcat_redirect_port*]
#   The port that tomcat will be configured for its redirection.
#
# [*tomcat_catalina_opts_xmx*]
#   The CATALINA_OPTS for setting the maximum tomcat memory size (-Xmx)
#
# [*tomcat_catalina_opts_maxpermsize*]
#   The CATALINA_OPTS for setting the max tomcat memory perm size (-XX:MaxPermSize=)
#
# 
# [*tomcat_catalina_opts_multicastaddr*]
#   The CATALINA_OPTS for setting the max tomcat jgroups udp mcast address (-Djgroups.udp.mcast_addr=)
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

    # Note: user and group have to be set using the tomcat class in the user's nodes.pp
    # Puppet configuration for tomcat, at least until an updated version of Puppetlabs
    # Tomcat has been released.
    $user                = 'fcrepo'
    $group               = 'fcrepo'
    $user_profile        = '/home/fcrepo/.bashrc'
    $fcrepo_sandbox_home = '/fedora'
    $fcrepo_datadir      = '/data'
    $fcrepo_configdir    = '/fedora/config'
    $fcrepo_configtype   = 'fcrepo-4.4.0-minimal-default'
    $fcrepo_warsource    = 'https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.4.0/fcrepo-webapp-4.4.0.war'
    $java_homedir        = '/usr/java/default'
    $tomcat_source       = 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz'
    $tomcat_deploydir    = '/fedora/tomcat7'
    $tomcat_install_from_source = true
    $tomcat_http_port    = '8080'
    $tomcat_ajp_port     = '8009'
    $tomcat_redirect_port = '8443'
    $tomcat_catalina_opts_xmx = '1024m'
    $tomcat_catalina_opts_maxpermsize = '256m'
    $tomcat_catalina_opts_multicastaddr = '192.168.254.254'
}

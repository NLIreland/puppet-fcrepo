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
# [*java_source*]
#   The Java source file, under files/.
#
# [*java_deploydir*]
#   The Java base directory (JAVA_HOME).
#
# [*maven_source*]
#   The Maven source file, under files/.
#
# [*maven_deploydir*]
#   The Maven base directory.
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
    $fcrepo_configdir      = '/fedora/config'
    $java_source         = 'jdk-7u51-linux-x64.tar.gz'
    $java_deploydir      = '/fedora/java7'
    $maven_source        = 'apache-maven-3.1.1-bin.tar.gz'
    $maven_deploydir     = '/fedora/maven3'
    $tomcat_source        = 'apache-tomcat-7.0.50.tar.gz'
    $tomcat_deploydir     = '/fedora/tomcat7'
}

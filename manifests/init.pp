# == Class: fcrepo
#
# Fedora 4 management module to install and configure Fedora in
# a clustered environment.
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
#   Base directory for the Fedora 4 sandbox environment.  Java, Maven, Tomcat,
#   and Fedora will be installed under this directory.
#
# [*fcrepo_datadir*]
#   Fedora 4 data directory.
#
# [*fcrepo_configdir*]
#   Fedora 4 config directory.
#
# [*java_source*]
#   The Java source package name (should be installed under files/)
#
# [*java_deploydir*]
#   The Java base directory (i.e., JAVA_HOME).
#
# [*maven_source*]
#   The Maven source package name (should be installed under files/)
#
# [*maven_deploydir*]
#   The Maven base directory
#
# [*tomcat_source*]
#   The Tomcat source package name (should be installed under files/)
#
# [*tomcat_deploydir*]
#   The Tomcat base directory (CATALINA_HOME)
#
# === Variables
#
# None at this time.
#
# === Examples
#
#  class { fcrepo:
#    fcrepo_sandbox_home => '/opt/fcrepo',
#  }
#
# === Authors
#
# Scott Prater <sprater@gmail.com>
#
# === Copyright
#
# Copyright 2014 Scott Prater
#
class fcrepo (

  $user                = 'UNSET',
  $group               = 'UNSET',
  $user_profile        = 'UNSET',
  $fcrepo_sandbox_home = 'UNSET',
  $fcrepo_datadir      = 'UNSET',
  $fcrepo_configdir    = 'UNSET',
  $java_source         = 'UNSET',
  $java_deploydir      = 'UNSET',
  $maven_source        = 'UNSET',
  $maven_deploydir     = 'UNSET',
  $tomcat_source       = 'UNSET',
  $tomcat_configs    = 'UNSET',
  $tomcat_runtimes    = 'UNSET',
  $tomcat_webapps    = 'UNSET',

) {

#  include stdlib
#  include java
  #include maven
#  include tomcat
  include fcrepo::params

  validate_string($fcrepo::params::user)
  validate_string($fcrepo::params::group)
#  validate_re($fcrepo::params::java_source, '.tar.gz$',
#    'The Java source file is not a tar-gzipped file.')
#  validate_re($fcrepo::params::maven_source, '.tar.gz$',
#    'The Maven source file is not a tar-gzipped file.')
#  validate_re($fcrepo::params::tomcat_source, '.tar.gz$',
#    'The Tomcat source file is not a tar-gzipped file.')
#  validate_absolute_path($fcrepo::params::user_profile)
  validate_absolute_path($fcrepo::params::fcrepo_sandbox_home)
  validate_absolute_path($fcrepo::params::fcrepo_datadir)
  validate_absolute_path($fcrepo::params::fcrepo_configdir)
#  validate_absolute_path($fcrepo::params::java_deploydir)
#  validate_absolute_path($fcrepo::params::maven_deploydir)
  validate_absolute_path($fcrepo::params::tomcat_runtimes)
  validate_absolute_path($fcrepo::params::tomcat_configs)
  validate_absolute_path($fcrepo::params::tomcat_webapps)

  $user_real = $user? {
    'UNSET' => $::fcrepo::params::user,
    default => $user,
  }

  $group_real = $group? {
    'UNSET' => $::fcrepo::params::group,
    default => $group,
  }

#  $user_profile_real = $user_profile? {
#    'UNSET' => $::fcrepo::params::user_profile,
#    default => $user_profile,
#  }

  $fcrepo_sandbox_home_real = $fcrepo_sandbox_home? {
    'UNSET' => $::fcrepo::params::fcrepo_sandbox_home,
    default => $fcrepo_sandbox_home,
  }

  $fcrepo_datadir_real = $fcrepo_datadir? {
    'UNSET' => $::fcrepo::params::fcrepo_datadir,
    default => $fcrepo_datadir,
  }

  $fcrepo_configdir_real = $fcrepo_configdir? {
    'UNSET' => $::fcrepo::params::fcrepo_configdir,
    default => $fcrepo_configdir,
  }

#  $java_source_real = $java_source? {
#    'UNSET' => $::fcrepo::params::java_source,
#    default => $java_source,
#  }

#  $java_deploydir_real = $java_deploydir? {
#    'UNSET' => $::fcrepo::params::java_deploydir,
#    default => $java_deploydir,
#  }

#  $maven_source_real = $maven_source? {
#    'UNSET' => $::fcrepo::params::maven_source,
#    default => $maven_source,
#  }

#  $maven_deploydir_real = $maven_deploydir? {
#    'UNSET' => $::fcrepo::params::maven_deploydir,
#    default => $maven_deploydir,
#  }

#  $tomcat_source_real = $tomcat_source? {
#    'UNSET' => $::fcrepo::params::tomcat_source,
#    default => $tomcat_source,
#  }

  $tomcat_configs_real = $tomcat_configs? {
    'UNSET' => $::fcrepo::params::tomcat_configs,
    default => $tomcat_configs,
  }
  $tomcat_runtimes_real = $tomcat_runtimes? {
    'UNSET' => $::fcrepo::params::tomcat_runtimes,
    default => $tomcat_runtimes,
  }
  $tomcat_webapps_real = $tomcat_webapps? {
    'UNSET' => $::fcrepo::params::tomcat_webapps,
    default => $tomcat_webapps,
  }

# Using the anchor containment pattern for backwards compatibility (< 3.4.0)
  anchor { 'fcrepo::begin': } ->
  class { '::fcrepo::install': } ->
  class { '::fcrepo::config': } ~>
#  class { '::fcrepo::service': } ->
  anchor { 'fcrepo::end': }
}

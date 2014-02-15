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
# [*java_source*]
#   The java source package name (should be installed under files/source)
#
# [*java_deploydir*]
#   The Java base directory (i.e., JAVA_HOME).
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
  $java_source         = 'UNSET',
  $java_deploydir      = 'UNSET',
) {

  include stdlib
  include java
  include maven
  include tomcat
  include fcrepo::params

  validate_string($fcrepo::params::user)
  validate_string($fcrepo::params::group)
  validate_re($fcrepo::params::java_source, '.tar.gz$',
    'The java source file is not a tar-gzipped file.')
  validate_absolute_path($fcrepo::params::user_profile)
  validate_absolute_path($fcrepo::params::fcrepo_sandbox_home)
  validate_absolute_path($fcrepo::params::fcrepo_datadir)
  validate_absolute_path($fcrepo::params::java_deploydir)

  $user_real = $user? {
    'UNSET' => $::fcrepo::params::user,
    default => $user,
  }

  $group_real = $group? {
    'UNSET' => $::fcrepo::params::group,
    default => $group,
  }

  $user_profile_real = $user_profile? {
    'UNSET' => $::fcrepo::params::user_profile,
    default => $user_profile,
  }

  $fcrepo_sandbox_home_real = $fcrepo_sandbox_home? {
    'UNSET' => $::fcrepo::params::fcrepo_sandbox_home,
    default => $fcrepo_sandbox_home,
  }

  $fcrepo_datadir_real = $fcrepo_datadir? {
    'UNSET' => $::fcrepo::params::fcrepo_datadir,
    default => $fcrepo_datadir,
  }

  $java_source_real = $java_source? {
    'UNSET' => $::fcrepo::params::java_source,
    default => $java_source,
  }

  $java_deploydir_real = $java_deploydir? {
    'UNSET' => $::fcrepo::params::java_deploydir,
    default => $java_deploydir,
  }

# Using the anchor containment pattern for backwards compatibility (< 3.4.0)
  anchor { 'fcrepo::begin': } ->
  class { '::fcrepo::install': } ->
#  class { '::fcrepo::config': } ~>
#  class { '::fcrepo::service': } ->
  anchor { 'fcrepo::end': }
}

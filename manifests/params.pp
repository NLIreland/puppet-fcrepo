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
# [*fcrepo_sandbox_home*]
#   The base directory where Fedora and its supporting infrastructure software
#   will be installed.
#
# [*fcrepo_datadir*]
#   The Fedora data directory.
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
    $fcrepo_sandbox_home = '/fedora'
    $fcrepo_datadir      = '/data'
}

# == Class: fcrepo
#
# Fedora 4 management module to install and configure Fedora in
# a clustered environment.
#
# === Parameters
#
# Document parameters here.
#
# [*config*]
#   The suite of config files to deploy
#
# === Variables
#
# None at this time.
#
# === Examples
#
#  class { fcrepo:
#    config => 'infinispan',
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
class fcrepo {

    include stdlib

}

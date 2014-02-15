####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Prerequisites](#prerequisites)
3. [Setup - The basics of getting started with fcrepo](#setup)
    * [What fcrepo affects](#what-fcrepo-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with fcrepo](#beginning-with-fcrepo)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The fcrepo module installs, configures, and manages Fedora 4 in a clustered 
environment.

##Module Description

The fcrepo module manages running Fedora repositories in a clustered 
environment.  The module ensures that the prerequisite  software is installed, 
installs the Fedora WAR file and sets up the FCREPO_HOME directory, and manages 
the configuration files for every Fedora instance on each node in the cluster.

##Prerequisites

To use this module, you need Puppet installed (of course), as well as
the following Puppet modules:

* puppetlabs/stdlib
* 7terminals/java
* 7terminals/maven
* 7terminals/tomcat

###Install and configure a base installation of Puppet

Puppet Labs has good step-by-step documentation for getting a Puppet master 
and Puppet clients set up.

Install:  <http://docs.puppetlabs.com/guides/installation.html>

Setup:  <http://docs.puppetlabs.com/guides/setting_up.html>

Make sure your agents can contact the master puppet server and receive their 
catalog information:

```sudo puppet agent --test```

###Install the extra Puppet modules

```
sudo puppet module install puppetlabs/stdlib
sudo puppet module install 7terminals/java
sudo puppet module install 7terminals/maven
sudo puppet module install 7terminals/tomcat
```

##Setup

###What fcrepo affects

* Java, Tomcat, Maven standalone installs
* Fedora WAR
* Fedora directories (home and data)
* Fedora configuration files
* Tomcat service

This module creates a user and group to manage the Fedora service and files,
creates a software directory and a data directory and assigns ownership of
them to the fedora user, then installs standalone versions of Oracle Java
HotSpot JDK, Tomcat, and Maven.  The module installs Fedora in a
sandboxed environment, with infarstructure software downloaded and
installed from source, and should work on any Unix environment.

It also deploys the Fedora WAR and Fedora configuration files.

###Beginning with fcrepo

####Install the module

Clone this project, change to the `puppet-fcrepo` directory, and run 
these commands:

    puppet module build .
    sudo puppet module install pkg/sprater-fcrepo-<version>.tar.gz

where `<version>` is the current version of the module.

####Enable the module in Puppet

include '::fcrepo' is enough to get you up and running.  If you wish to pass in
parameters like which servers to use then you can use:                                                                                    
```puppet                                                                                                                                 
class { '::fcrepo':                                                                                                                          
  user                => 'fcrepo',                                                                                        
  group               => 'fcrepo',                                                                                        
  fcrepo_sandbox_home => '/opt/fcrepo',
  fcrepo_datadir      => '/opt/fcrepo/data',
}
```

##Usage

##Reference

###Classes

####Public Classes

* fcrepo:  Main class, includes all other classes

####Private Classes

* fcrepo::install: Handles the packages.
* fcrepo::config: Handles the configuration files.
* fcrepo::service: Handles the service.

###Parameters

The following parameters are available in the fcrepo module:

####`user`

The Unix user that will own the Fedora directories, software, and data.

####`group`

The Unix group that will own the Fedora directories, software, and data.

####`fcrepo_sandbox_home`

The home directory for the Fedora environment sandbox.

####`fcrepo_datadir`

The Fedora data directory.

##Limitations

This module does not define the raw filesystem devices, nor mount
any filesystems.  Make sure the filesystem(s) in which the sandbox
and data directories will reside are created and mounted.

This module does not set a password for the Fedora Unix user.  You'll
need to do that yourself.

##Development

See the [DEVELOPERS](DEVELOPERS.md) file for more information on modifying, 
testing, and building this module.

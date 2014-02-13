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
environment.  The module ensures that the package prerequisites are installed, 
installs the Fedora WAR file and sets up the FCREPO_HOME directory, and manages 
the configuration files for every Fedora instance on each node in the cluster.

##Prerequisites

To use this module, you need Puppet installed (of course).

###Install and configure a base installation of Puppet

Puppet Labs has good step-by-step documentation for getting a Puppet master 
and Puppet clients set up.

Install:  <http://docs.puppetlabs.com/guides/installation.html>

Setup:  <http://docs.puppetlabs.com/guides/setting_up.html>

Make sure your agents can contact the master puppet server and receive their 
catalog information:

```sudo puppet agent --test```

##Setup

###What fcrepo affects

* Java, Tomcat, Maven, and Git packages
* Fedora WAR
* Fedora directories (home and data)
* Fedora configuration files
* Tomcat service

###Beginning with fcrepo
                                                                                                                                          
include '::fcrepo' is enough to get you up and running.  If you wish to pass in                                                           
parameters like which servers to use then you can use:                                                                                    
                                                                                                                                          
```puppet                                                                                                                                 
class { '::fcrepo':                                                                                                                          
  config => 'infinispan',                                                                                        
}
```

###Usage

###Reference

###Limitations

###Development

See the [DEVELOPERS](DEVELOPERS.md) file for more information on modifying, 
testing, and building this module.

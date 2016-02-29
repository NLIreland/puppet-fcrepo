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

The fcrepo module installs, configures, and manages Fedora 4 in a single or clustered 
environment.

##Module Description

The fcrepo module manages running Fedora 4 repositories in a single or a clustered 
environment.  The module installs Tomcat,
installs the Fedora WAR file and sets up the FCREPO_HOME directory. It can be used to manage 
the configuration files for every Fedora instance on each node in the cluster.

##Prerequisites

To use this module, you need:

1. Puppet installed (of course). This has been tested with Puppet 3.8.1. 
2. The following Puppet modules:
    * puppetlabs/stdlib
    * puppetlabs/tomcat
    Note: Version 1.4.1 available on puppetforge doesn't work correctly -- it only
    allows one user and group to be set per node. There is an update on github which fixes
    this issue. Use these commands to install puppetlabs/tomcat:
    ```
    git clone https://github.com/steve-didomenico/puppetlabs-tomcat/tree/ticket/MODULES-3117-user_and_group_per_instance_fix
    ```
    And then to install:
    ```
    puppet module install /path/to/puppetlabs-tomcat --modulepath /path/to/modules
    ```
3. Java already installed on the machine. Usually this can be installed by either:
    * Setting up your OS's packaged Java via Puppet by using the official puppetlabs/java 
    module. This should configure the proper path to the Java installation.
    * Installing a package (such as Oracle's Java RPM), which also sets up the proper path.
    Installing this via a local yum repository can allow Puppet to easily install this 
    for your machines.

###Install and configure a base installation of Puppet

Puppet Labs has good step-by-step documentation for getting a Puppet master 
and Puppet clients set up.

Install:  <http://docs.puppetlabs.com/guides/installation.html>

Setup:  <http://docs.puppetlabs.com/guides/setting_up.html>

Make sure your agents can contact the master puppet server and receive their 
catalog information:

```sudo puppet agent --test```

###Common Puppet Setup Issues

 * Make sure hosts are all time synch'ed via NTP
 * Use lowercase hostnames, including DNS entries
 * Only install the version of Ruby that is required by the puppetmaster package (Ubuntu)
 * If your host uses a web proxy, include that directive in puppet.conf and also set environment variables. Both are required for module installation.

  
```
http_proxy_host=myproxy.example.com
http_proxy_port=3128
```

```
$ export https_proxy=http://myproxy.example.com:3128
$ export http_proxy=http://myproxy.example.com:3128
```

###Install the extra Puppet modules on your puppet master

```
sudo puppet module install puppetlabs/stdlib
sudo puppet module install puppetlabs/tomcat (note: see above about installing the correct version)
```

##Setup

###What fcrepo affects

* Fedora service user and group
* Tomcat standalone install
* Fedora WAR
* Fedora directories (home and data)
* Fedora configuration files
* Tomcat service

This module creates a user and group to manage the Fedora service and files,
creates a software directory and a data directory and assigns ownership of
them to the fedora user, then installs standalone versions of Tomcat.  
The module installs Fedora in a
sandboxed environment, with infrastructure software downloaded and
installed from binary distributions, and should work on any Unix environment.

It also deploys the Fedora WAR and Fedora configuration files,
and manages the Fedora Tomcat service.

###Beginning with fcrepo

####Build and install the module

1. Clone this project, change to the `puppet-fcrepo` directory. 

2. Build the module: 

```
    puppet module build .
```

3. Install the module:

```
    sudo puppet module install pkg/sprater-fcrepo-<version>.tar.gz --ignore-dependencies
```

   where `<version>` is the current version of the module.

####Enable the module in Puppet

`include 'fcrepo'` in the puppet master's `site.pp` file (located in manifests folder) is enough to get 
you up and running.  If you wish to pass in parameters such as which user and
group to create then you can use instead:                                                                                    

```puppet                                                                                                                                 
class { '::fcrepo':
  user                => 'tomcat',
  group               => 'tomcat',
  user_profile        => '/home/tomcat/.bashrc',
  tomcat_deploydir    => '/fedora/tomcat7',
  fcrepo_sandbox_home => '/fedora',
  fcrepo_datadir      => '/fedora/data',
  fcrepo_configdir    => '/fedora/config',
  fcrepo_configtype   => 'fcrepo-4.4.0-minimal-default',
}
```
Note: Placing the above include and class outside of specific node definitions, as above, will apply the fcrepo role to every puppet node. Alternately, place them within an appropriate node block.

And to startup the service, use:
```
fcrepo::service { 'tomcat-fcrepo':
  service_enable      => true,
  service_ensure      => 'running',
}
```

##Usage

##Reference

###Classes

####Public Classes

* fcrepo:  Main class, includes all other classes

####Private Classes

* fcrepo::install: Creates the user and group, ensures that the correct
  directories exist, and installs the base software and the Fedora WAR.
* fcrepo::config: Manages the configuration files.
* fcrepo::service: Manages the Tomcat service.

###Parameters

The following parameters are available in the fcrepo module.  They
are grouped into __Environment__, __Infrastructure__, and __Fedora__.

The defaults are defined in `fcrepo::params`, and may be changed there, or
overridden in the Puppet files that include the `fcrepo` class.

####Environment

#####`user`

The Unix user that will own the Fedora directories, software, and data.

Default: **fcrepo**

#####`group`

The Unix group that will own the Fedora directories, software, and data.

Default: **fcrepo**

Note: The user and group for Tomcat's startup needs to be set using the tomcat class and
should be included in your nodes.pp definition. This is due to a bug in the
puppetlabs/tomcat module and appears to be fixed in master (hopefully it won't be
too long before this fix is released).
```
  class { 'tomcat': 
    user  => 'fcrepo',
    group => 'fcrepo',
  }
```

#####`user_profile`

The absolute path to the shell profile file that should be modified to
update the PATH environment variable.  Can be set to a system-wide profile
(i.e. `/etc/profile`).

Default is **/home/_user_/.bashrc**

####Infrastructure

Software packages by default are installed in the Fedora 4 sandbox directory, owned
by the Fedora Unix user and group.  The user's PATH is modified to point first to 
these tools in the sandbox, and other environment variables may be set in the user's 
profile file.

#####`java_homedir`

The location where Java is installed; this variable is used to set JAVA_HOME. The default 
will attempt to use the Red Hat system Java location.

Default:  **/usr/java/default**

#####`tomcat_source`

The URL where Tomcat binary distribution package, can be found in *.tar.gz format.
The package will be automatically downloaded and installed.

Default:  **http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz**

#####`tomcat_deploydir`

The Tomcat base directory (CATALINA_HOME).

Default:  **_fcrepo sandbox home_/tomcat7**

#####`tomcat_install_from_source`

 A boolean which states whether the tomcat install should be done from a source .tar.gz file.
 * `true`  - means the tomcat installation will be down given the $tomcat_source file.
 * `false` - means that the tomcat installation will be done using the OS package.
 
Default: **true**

#####`tomcat_http_port`
   The port that tomcat will be configured to listen on for http connections.
   
Default: **8080**

#####`tomcat_ajp_port`
   The port that tomcat will be configured to listen for ajp connections
   
Default: **8009**

#####`tomcat_redirect_port`
   The port that tomcat will be configured for its redirection.

Default: **8443**

#####`tomcat_catalina_opts_xmx`
The CATALINA_OPTS for setting the maximum tomcat memory size (-Xmx)

Default: **1024m**

#####`tomcat_catalina_opts_maxpermsize`
The CATALINA_OPTS for setting the max tomcat memory perm size (-XX:MaxPermSize=)

Default: **256m**

#####`tomcat_catalina_opts_multicastaddr`
The CATALINA_OPTS for setting the max tomcat jgroups udp mcast address (-Djgroups.udp.mcast_addr=)

Default: **192.168.254.254**

#### Fedora

#####`fcrepo_sandbox_home`

The home directory for the Fedora environment sandbox.

Default: **/fedora**

#####`fcrepo_datadir`

The Fedora data directory.

Default: **/data**

#####`fcrepo_configdir`

The Fedora configuration directory.

Default: **/fedora/config**

#####`fcrepo_configdir`

The version and type of configuration files that should be used. The configuration files
can vary depending on whether you are using Fedora 4.4.0 or 4.5.0, and whether you are
running under a default (single) or clustered configuration. Some possible choices are:
* fcrepo-4.4.0-minimal-default
* fcrepo-4.4.0-clustered
* fcrepo-4.5.0-minimal-default
* fcrepo-4.5.0-clustered

The minimal default versions use these defaults from the fcrepo package, which includes
using leveldb for infinispan storage.

Default: **fcrepo-4.4.0-minimal-default**

#####`fcrepo_warsource`

The location where the Fedora 4 war file can be found for download.
Can be a string containing a puppet://, http(s)://, or ftp:// URL.
The warfile will be installed into Tomcat's webapps.

Default: **https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.4.0/fcrepo-webapp-4.4.0.war**

##Limitations

This module does not define the raw filesystem devices, nor mount
any filesystems.  Make sure the filesystem(s) in which the sandbox
and data directories will reside are created and mounted.

This module does not set a password for the Fedora Unix user.  You'll
need to do that yourself.

##Development

See the [DEVELOPERS](DEVELOPERS.md) file for more information on modifying, 
testing, and building this module.

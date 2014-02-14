# Developer's Guide

1. [Set up the environment](#set-up-the-environment)
2. [Check the formatting](#check-the-formatting)
3. [Run the tests](#run-the-tests)
4. [Build the module](#build-the-module)
5. [Install the module](#install-the-module)
6. [Other useful commands](#other-useful-commands)

##Set Up the Environment

Prerequisites:  puppet, ruby, gem, and the bundler and rcov (for code coverage 
checks) gems.

1. Clone this project:

```
    git clone git://github.com/sprater/puppet-fcrepo
    cd puppet-fcrepo
```


2. Set your environment variables:

```
    BUNDLE_GEMFILE=.gemfile
    export BUNDLE_GEMFILE
```

3. Install the gems needed for development and testing:

```
    bundle install --gemfile .gemfile
```


##Check the formatting

Make sure the module conforms to the [Puppet Labs Style Guide](http://docs.puppetlabs.com/guides/style_guide.html):

    rake lint

##Run the tests

Run the tests under the `spec/` directory:

    rake spec

##Build the module

Build the module as a tar-gzipped package, ready for install into puppet:

    rake build

##Install the module

Install the module, ignoring any upstream Puppet Forge dependencies:

    puppet module install fcrepo-<version>.tar.gz --ignore-dependencies

##Other useful commands

###Clean the built module package

    rake clean

###Check your test coverage

    rake coverage


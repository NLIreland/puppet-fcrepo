# spec/classes/fcrepo_spec.pp

require 'spec_helper'

describe 'fcrepo' do

  # Don't let java::setup stop us
  let :facts do
    {
      :osfamily => 'RedHat'
    }
  end

  it { should compile.with_all_deps }

  it 'includes stdlib' do
    should contain_class('stdlib')
  end

  it 'includes java' do
    should contain_class('java')
  end

  it 'includes maven' do
    should contain_class('maven')
  end

  it 'includes tomcat' do
    should contain_class('tomcat')
  end

  it { should contain_class('fcrepo') }
  it { should contain_class('fcrepo::install') }

  # Test group
  context "With no group specified" do
    it {
      should contain_group('fcrepo').with( { 'ensure' => 'present' } )
    }
  end

  context "With group specified" do
    let :params do
      {
        :group => 'fedora'
      }
    end
    it {
      should contain_group('fedora').with( { 'ensure' => 'present' } )
    }
  end

  # Test user
  context "With no user specified" do
    it {
      should contain_user('fcrepo').with( {
        'ensure'     => 'present',
        'gid'        => 'fcrepo',
        'shell'      => '/bin/bash',
        'home'       => '/home/fcrepo',
        'managehome' => true,
      } )
    }

    it {
      should contain_file('/home/fcrepo/.bashrc')
    }

  end

  context "With user specified" do
    let :params do
      {
        :user         => 'fedora',
        :user_profile => '/home/fedora/.bashrc'
      }
    end
    it {
      should contain_user('fedora').with( {
        'ensure'     => 'present',
        'gid'        => 'fcrepo',
        'shell'      => '/bin/bash',
        'home'       => '/home/fedora',
        'managehome' => true,
      } )
    }

    it {
      should contain_file('/home/fedora/.bashrc')
    }

  end

  context "With user and group specified" do
    let :params do
      {
        :user   => 'fedora',
        :group  => 'fedora',
      }
    end
    it {
      should contain_user('fedora').with( {
        'ensure'     => 'present',
        'gid'        => 'fedora',
        'shell'      => '/bin/bash',
        'home'       => '/home/fedora',
        'managehome' => true,
      } )
    }

  end

  # Test sandbox home
  context "With no sandbox directory specified" do
    it {
      should contain_file('/fedora').with( {
        'ensure'  => 'directory',
        'path'    => '/fedora',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0755',
      } )
    }
  end

  context "With sandbox directory specified" do
    let :params do
      {
        :fcrepo_sandbox_home => '/opt/fedora',
        :user                => 'drwho'
      }
    end
    it {
      should contain_file('/opt/fedora').with( {
        'ensure'  => 'directory',
        'path'    => '/opt/fedora',
        'group'   => 'fcrepo',
        'owner'   => 'drwho',
        'mode'    => '0755',
      } )
    }
  end

  # Test data directory home
  context "With no data directory specified" do
    it {
      should contain_file('/data').with( {
        'ensure'  => 'directory',
        'path'    => '/data',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0755',
      } )
    }
  end

  context "With data directory specified" do
    let :params do
      {
        :fcrepo_datadir => '/opt/fedora/data',
        :user           => 'sholmes'
      }
    end
    it {
      should contain_file('/opt/fedora/data').with( {
        'ensure'  => 'directory',
        'path'    => '/opt/fedora/data',
        'group'   => 'fcrepo',
        'owner'   => 'sholmes',
        'mode'    => '0755',
      } )
    }
  end

  # With user home directory
  context "With unspecified user's home directory" do
    it {
      should contain_file('/home/fcrepo').with( {
        'ensure'  => 'directory',
        'path'    => '/home/fcrepo',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0755',
      } )
    } 
  end

  context "With specified user's home directory" do
    let :params do
      {
        :user           => 'sholmes'
      }
    end
    it {
      should contain_file('/home/sholmes').with( {
        'ensure'  => 'directory',
        'path'    => '/home/sholmes',
        'group'   => 'fcrepo',
        'owner'   => 'sholmes',
        'mode'    => '0755',
      } )
    }
  end

  # Test Java install
  context "With default java_source and java_deploydir" do
    it {
      should contain_java__setup('jdk-7u51-linux-x64.tar.gz').with( {
        'source'        => 'jdk-7u51-linux-x64.tar.gz',
        'deploymentdir' => '/fedora/java7',
        'user'          => 'fcrepo',
        'pathfile'      => '/home/fcrepo/.bashrc'
      } )
    }
  end

  context "With specified java_source and default java_deploydir" do
    let :params do
      {
        :java_source    => 'testjavasource.tar.gz'
      }
    end
    it {
      should contain_java__setup('testjavasource.tar.gz').with( {
        'source'        => 'testjavasource.tar.gz',
        'deploymentdir' => '/fedora/java7',
        'user'          => 'fcrepo',
        'pathfile'      => '/home/fcrepo/.bashrc'
      } )
    }
  end

  context "With specified java_source and specified java_deploydir" do
    let :params do
      {
        :java_source    => 'testjavasource.tar.gz',
        :java_deploydir => '/opt/java/jdk7'
      }
    end
    it {
      should contain_java__setup('testjavasource.tar.gz').with( {
        'source'        => 'testjavasource.tar.gz',
        'deploymentdir' => '/opt/java/jdk7',
        'user'          => 'fcrepo',
        'pathfile'      => '/home/fcrepo/.bashrc'
      } )
    }
  end

  # Test Maven install
  context "With default maven_source and maven_deploydir" do
    it {
      should contain_maven__setup('apache-maven-3.1.1-bin.tar.gz').with( {
        'source'        => 'apache-maven-3.1.1-bin.tar.gz',
        'deploymentdir' => '/fedora/maven3',
        'user'          => 'fcrepo',
        'pathfile'      => '/home/fcrepo/.bashrc'
      } )
    }
  end

  context "With specified maven_source and default maven_deploydir" do
    let :params do
      {
        :maven_source    => 'testmavensource.tar.gz'
      }
    end
    it {
      should contain_maven__setup('testmavensource.tar.gz').with( {
        'source'        => 'testmavensource.tar.gz',
        'deploymentdir' => '/fedora/maven3',
        'user'          => 'fcrepo',
        'pathfile'      => '/home/fcrepo/.bashrc'
      } )
    }
  end

  context "With specified maven_source and specified maven_deploydir" do
    let :params do
      {
        :maven_source    => 'testmavensource.tar.gz',
        :maven_deploydir => '/opt/maven/maven3'
      }
    end
    it {
      should contain_maven__setup('testmavensource.tar.gz').with( {
        'source'        => 'testmavensource.tar.gz',
        'deploymentdir' => '/opt/maven/maven3',
        'user'          => 'fcrepo',
        'pathfile'      => '/home/fcrepo/.bashrc'
      } )
    }
  end

  # Test Tomcat install
  context "With default tomcat_source and tomcat_deploydir" do
    it {
      should contain_tomcat__setup('apache-tomcat-7.0.50.tar.gz').with( {
        'source'                     => 'apache-tomcat-7.0.50.tar.gz',
        'deploymentdir'              => '/fedora/tomcat7',
        'user'                       => 'fcrepo',
        'default_webapp_docs'        => 'absent',
        'default_webapp_examples'    => 'absent',
        'default_webapp_hostmanager' => 'absent',
        'default_webapp_manager'     => 'absent',
        'default_webapp_root'        => 'absent',
      } )
    }
  end

  context "With specified tomcat_source and default tomcat_deploydir" do
    let :params do
      {
        :tomcat_source    => 'testtomcatsource.tar.gz'
      }
    end
    it {
      should contain_tomcat__setup('testtomcatsource.tar.gz').with( {
        'source'                     => 'testtomcatsource.tar.gz',
        'deploymentdir'              => '/fedora/tomcat7',
        'user'                       => 'fcrepo',
        'default_webapp_docs'        => 'absent',
        'default_webapp_examples'    => 'absent',
        'default_webapp_hostmanager' => 'absent',
        'default_webapp_manager'     => 'absent',
        'default_webapp_root'        => 'absent',
      } )
    }
  end

  context "With specified tomcat_source and specified tomcat_deploydir" do
    let :params do
      {
        :tomcat_source    => 'testtomcatsource.tar.gz',
        :tomcat_deploydir => '/opt/tomcat/tomcat7'
      }
    end
    it {
      should contain_tomcat__setup('testtomcatsource.tar.gz').with( {
        'source'                     => 'testtomcatsource.tar.gz',
        'deploymentdir'              => '/opt/tomcat/tomcat7',
        'user'                       => 'fcrepo',
        'default_webapp_docs'        => 'absent',
        'default_webapp_examples'    => 'absent',
        'default_webapp_hostmanager' => 'absent',
        'default_webapp_manager'     => 'absent',
        'default_webapp_root'        => 'absent',
      } )
    }
  end

end

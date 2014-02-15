# spec/classes/fcrepo_spec.pp

require 'spec_helper'

describe 'fcrepo' do

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
  end

  context "With user specified" do
    let :params do
      {
        :user => 'fedora'
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

end

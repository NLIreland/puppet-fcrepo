# spec/classes/fcrepo_spec.pp

require 'spec_helper'

describe 'fcrepo' do

  it 'includes stdlib' do
    should include_class('stdlib')
  end

end

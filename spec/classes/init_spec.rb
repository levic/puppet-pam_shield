require 'spec_helper'
describe 'pam_shield' do

  context 'with defaults for all parameters' do
    it { should contain_class('pam_shield') }
  end
end

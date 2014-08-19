require 'spec_helper'

describe 'pam_shield' do

  let(:title) { 'pam_shield' }

#  context 'with defaults for all parameters' do
  it { should contain_class('pam_shield') }

  let(:params) do
    {
     'allow_missing_dns'     => true,
     'allow_missing_reverse' => true,
     'allow                ' => true,
    }
  end

#    before :each do
#      params.merge!(
#        :allow_missing_dns     => true,
#        :allow_missing_reverse => true,
#        :max_conns             => 5,
#        :interval              => '1m',
#        :retention             => '4m',
#        :allow                 => true,
#        :selinux_policy        => false,
#      )
#    end

  it "installs package: pam_shield" do
    should contain_package('pam_shield')
  end
 # end
end

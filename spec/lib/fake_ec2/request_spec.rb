require 'spec_helper'
require 'fake_ec2/request'
describe FakeEc2::Request do
  context 'Action=RunInstances' do
    subject do
      described_class.from_param_string '?Action=RunInstances'
    end

    its(:action_class) { should == FakeEc2::Action::RunInstances }
    its(:action) { should be_an_instance_of FakeEc2::Action::RunInstances }
  end
end

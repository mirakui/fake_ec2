require 'spec_helper'
require 'fake_ec2/model/instance'

describe FakeEc2::Model::Instance do
  specify do
    ins = described_class.new
    ins.instance_id.should =~ /^i-[0-9a-z]{8}$/
    ins.instance_state.should == { code: 0, name: 'pending' }
  end
end

require 'spec_helper'
require 'fake_ec2/model/tag'

describe FakeEc2::Model::Tag do
  subject(:tag) { described_class.new resource_id: 'i-001', key: 'Key1', value: 'Value1' }
  it { subject.resource_id.should == 'i-001' }
  it { subject.key.should == 'Key1' }
  it { subject.value.should == 'Value1' }
  it { subject.resource_type.should == 'instance' }
end

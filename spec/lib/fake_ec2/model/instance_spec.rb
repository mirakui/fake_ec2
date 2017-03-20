require 'spec_helper'
require 'fake_ec2/model/instance'

describe FakeEc2::Model::Instance.new do
  it { expect(subject.instance_id).to match /^i-[0-9a-z]{8}$/ }
  it { expect(subject.instance_state).to match code: 0, name: 'pending' }
end

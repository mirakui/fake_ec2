require 'spec_helper'
require 'fake_ec2/model/tag'

describe FakeEc2::Model::Tag do
  subject(:tag) { described_class.new resource_id: 'i-001', key: 'Key1', value: 'Value1' }
  it { expect(tag.resource_id).to eq 'i-001' }
  it { expect(tag.key).to eq 'Key1' }
  it { expect(tag.value).to eq 'Value1' }
  it { expect(tag.resource_type).to eq 'instance' }
end

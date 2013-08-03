require 'spec_helper'
require 'fake_ec2/action'

describe FakeEc2::Action::DescribeInstances do
  let(:action) { described_class.new }
  let(:space) { FakeEc2.space }
  before { space.clear }

  describe '#run' do
    before do
      space.instances << FakeEc2::Model::Instance.new(
        instance_id:    'i-001',
        reservation_id: 'r-001'
      )
      space.instances << FakeEc2::Model::Instance.new(
        instance_id:    'i-002',
        reservation_id: 'r-001'
      )
      space.instances << FakeEc2::Model::Instance.new(
        instance_id:    'i-003',
        reservation_id: 'r-002'
      )
      space.tags << FakeEc2::Model::Tag.new(
        resource_id:    'i-001',
        key:            'Key1',
        value:          'Value1'
      )
    end
    subject!(:result) { action.run({}) }
    let(:instance1) { result[:reservation_set][0][:item][:instances_set][0][:item] }
    let(:instance2) { result[:reservation_set][0][:item][:instances_set][1][:item] }
    let(:instance3) { result[:reservation_set][1][:item][:instances_set][0][:item] }

    it { expect(instance1[:instance_id]).to eq('i-001') }
    it { expect(instance2[:instance_id]).to eq('i-002') }
    it { expect(instance3[:instance_id]).to eq('i-003') }

    it { expect(instance1[:tag_set][0][:item][:key]).to eq('Key1') }
    it { expect(instance1[:tag_set][0][:item][:value]).to eq('Value1') }
  end
end

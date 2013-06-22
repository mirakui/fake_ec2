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
    end
    subject { action.run({}) }

    its([:reservation_set]) { should have(2).reservations }
    specify do
      r1 = subject[:reservation_set][0][:item][:instances_set]
      r1.should have(2).items
      r1[0][:item][:instance_id].should == 'i-001'
      r1[1][:item][:instance_id].should == 'i-002'

      r2 = subject[:reservation_set][1][:item][:instances_set]
      r2[0][:item][:instance_id].should == 'i-003'
    end
  end
end

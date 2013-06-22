require 'spec_helper'
require 'fake_ec2/action'

describe FakeEc2::Action::RunInstances do
  let(:action) { described_class.new }
  let(:space) { FakeEc2.space }

  before { space.clear }

  describe '#run' do
    subject! do
      action.run(
        image_id: 'ami-00000001',
        instance_type: 't1.micro',
        key_name: 'my_key',
        security_groups: [],
        min_count: 1,
        max_count: 10
      )
    end

    it { should be_a(Hash) }
    its([:request_id]) { should =~ /^[\w\-]+$/ }
    its([:instances_set]) { should be_a(Array) }
    its([:instances_set]) { should have(10).instances }
    specify do
      space.instances.should have(10).instances
    end
  end
end

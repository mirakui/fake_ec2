require 'spec_helper'
require 'fake_ec2/action'

describe FakeEc2::Action::RunInstances do
  let(:action) { described_class.new }
  let(:space) { FakeEc2.space }

  before { space.clear }

  describe '#run' do
    let!(:result) do
      action.run(
        image_id: 'ami-00000001',
        instance_type: 't1.micro',
        key_name: 'my_key',
        security_groups: [],
        min_count: 1,
        max_count: 10
      )
    end
    let(:instances) { space.instances }

    subject { result }

    it { should be_a(Hash) }
    its([:request_id]) { should =~ /\A[\w\-]+\z/ }
    its([:instances_set]) { should be_a(Array) }
    its([:instances_set]) { should have(10).items }

    specify do
      subject[:instances_set].first[:item][:instance_state].should include(code: 0, name: 'pending')
    end

    specify { instances.should have(10).instances }

    describe 'a instance' do
      subject { instances.first }
      its(:instance_state) { should include(code: 16, name: 'running') }
      its(:reservation_id) { should =~ /\Ar-\w+\z/ }
    end
  end
end

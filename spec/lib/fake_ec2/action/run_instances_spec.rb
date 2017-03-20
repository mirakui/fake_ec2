require 'spec_helper'
require 'fake_ec2/action'

describe FakeEc2::Action::RunInstances do
  let(:space) { FakeEc2.space }

  before { space.clear }

  describe '#run' do
    let!(:result) do
      described_class.new(
        image_id: 'ami-00000001',
        instance_type: 't1.micro',
        key_name: 'my_key',
        security_groups: [],
        min_count: 1,
        max_count: 10
      ).run
    end
    let(:instances) { space.instances }

    subject { result }

    it { should be_a(Hash) }
    it { subject[:request_id].should =~ /\A[\w\-]+\z/ }
    it { subject[:instances_set].should be_a(Array) }
    it { subject[:instances_set].length.should == 10 }

    specify do
      subject[:instances_set].first[:item][:instance_state].should include(code: 0, name: 'pending')
    end

    specify { instances.length.should == 10 }

    describe 'a instance' do
      subject { instances.first }
      it { subject.instance_state.should include(code: 16, name: 'running') }
      it { subject.reservation_id.should =~ /\Ar-\w+\z/ }
    end
  end
end

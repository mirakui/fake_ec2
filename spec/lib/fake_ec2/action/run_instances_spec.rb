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

    it { is_expected.to be_a Hash }
    it { expect(subject[:request_id]).to match /\A[\w\-]+\z/ }
    it { expect(subject[:instances_set]).to be_a Array }
    it { expect(subject[:instances_set].length).to eq 10 }

    it do
      expect(subject[:instances_set].first[:item][:instance_state]).to match(code: 0, name: 'pending')
    end

    it { expect(instances.length).to eq 10 }

    describe 'an instance' do
      subject { instances.first }
      it { expect(subject.instance_state).to match(code: 16, name: 'running') }
      it { expect(subject.reservation_id).to match /\Ar-\w+\z/ }
    end
  end
end

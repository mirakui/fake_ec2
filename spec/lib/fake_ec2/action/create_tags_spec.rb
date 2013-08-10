require 'spec_helper'
require 'fake_ec2/action'
require 'fake_ec2/model'

describe FakeEc2::Action::CreateTags do
  let(:space) { FakeEc2.space }
  before { space.clear }

  describe '#run' do
    subject!(:result) do
      described_class.new(
        resource_id: %w(ami-001 i-001),
        tag: [
          { key: 'Key1', value: 'Value1' },
          { key: 'Key2', value: 'Value2' }
        ]
      ).run
    end

    it { expect(result[:return]).to eq('true') }
    it { expect(space.tags).to have(4).items }
    it { expect(space.tags.first.resource_id).to eq('ami-001') }
    it { expect(space.tags.first.key).to eq('Key1') }
    it { expect(space.tags.first.value).to eq('Value1') }
  end
end


require 'spec_helper'
require 'fake_ec2/action'

describe FakeEc2::Action::DescribeTags do
  let(:space) { FakeEc2.space }
  before { space.clear }

  describe '#run' do
    before do
      space.tags << FakeEc2::Model::Tag.new(
        resource_id: 'i-001',
        key: 'Key1',
        value: 'Value1'
      )
      space.tags << FakeEc2::Model::Tag.new(
        resource_id: 'ami-001',
        key: 'Key2',
        value: 'Value2'
      )
    end
    subject(:result) { described_class.new.run }

    its([:tag_set]) { should have(2).sets }
    it { expect(result[:tag_set][0][:item][:resource_id]).to eq('i-001') }
    it { expect(result[:tag_set][0][:item][:key]).to eq('Key1') }
    it { expect(result[:tag_set][0][:item][:value]).to eq('Value1') }
    it { expect(result[:tag_set][0][:item][:resource_type]).to eq('instance') }

    it { expect(result[:tag_set][1][:item][:resource_id]).to eq('ami-001') }
    it { expect(result[:tag_set][1][:item][:key]).to eq('Key2') }
    it { expect(result[:tag_set][1][:item][:value]).to eq('Value2') }
    it { expect(result[:tag_set][1][:item][:resource_type]).to eq('image') }
  end
end

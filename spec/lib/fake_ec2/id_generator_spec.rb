require 'spec_helper'
require 'fake_ec2/id_generator'

describe FakeEc2::IdGenerator.new do
  before { subject.clear }

  describe '#generate_8hex' do
    it { expect(subject.generate_8hex('sg')).to match /^sg-[0-9a-z]{8}$/ }

    it 'should generate unique ids' do
      ids = []
      100.times { ids << subject.generate_8hex('sg') }
      expect(ids.uniq.length).to eq 100
    end
  end

  describe '#generate_request_id' do
    it do
      expect(subject.generate_request_id).to match(
        /^[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}$/
      )
    end
  end
end

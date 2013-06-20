require 'spec_helper'
require 'fake_ec2/id_generator'

describe FakeEc2::IdGenerator do
  subject { described_class.new }
  before { subject.clear }

  describe '#generate_8hex' do
    specify do
      subject.generate_8hex('sg').should =~ /^sg-[0-9a-z]{8}$/
    end

    it 'should generate unique ids' do
      ids = []
      100.times { ids << subject.generate_8hex('sg') }
      ids.uniq.length.should == 100
    end
  end

  describe '#generate_request_id' do
    specify do
      subject.generate_request_id.should =~
        /^[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}$/
    end
  end
end

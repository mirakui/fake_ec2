require 'spec_helper'
require 'fake_ec2/space'

describe FakeEc2::Space do
  subject { described_class.new }

  it { subject.id_generator.should be_a(FakeEc2::IdGenerator) }
  it { subject.ip_addr_generator.should be_a(FakeEc2::IpAddrGenerator) }

  describe 'serialization and deserialization' do
    let(:space) { described_class.new }

    subject do
      space.id_generator
      space.ip_addr_generator
      space.dump
    end

    it { should be_a(String) }
  end
end

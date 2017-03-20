require 'spec_helper'
require 'fake_ec2/space'

describe FakeEc2::Space do
  let(:space) { described_class.new }

  it { expect(space.id_generator).to be_a FakeEc2::IdGenerator }
  it { expect(space.ip_addr_generator).to be_a FakeEc2::IpAddrGenerator }

  describe 'serialization and deserialization' do
    it { expect(space.dump).to be_a String }
  end
end

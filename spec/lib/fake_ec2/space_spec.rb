require 'spec_helper'
require 'fake_ec2/space'

describe FakeEc2::Space do
  subject { described_class.new }

  its(:id_generator) { should be_a(FakeEc2::IdGenerator) }
  its(:ip_addr_generator) { should be_a(FakeEc2::IpAddrGenerator) }
end

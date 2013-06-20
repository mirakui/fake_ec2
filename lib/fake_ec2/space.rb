require 'fake_ec2'

module FakeEc2
  class Space
    def initialize
      @attributes = {}
    end

    def id_generator
      @attributes[:id_generator] ||= FakeEc2::IdGenerator.new
    end

    def ip_addr_generator
      @attributes[:ip_addr_generator] ||= FakeEc2::IpAddrGenerator.new
    end
  end
end

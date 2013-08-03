require 'fake_ec2'

module FakeEc2
  class Space
    def initialize
      clear
    end

    def id_generator
      @attributes[:id_generator] ||= IdGenerator.new
    end

    def ip_addr_generator
      @attributes[:ip_addr_generator] ||= IpAddrGenerator.new
    end

    def instances
      @attributes[:instances] ||= Model::Set.new
    end

    def tags
      @attributes[:tags] ||= Model::Set.new
    end

    def clear
      @attributes = {}
    end

    def dump
      Marshal.dump @attributes
    end
  end
end

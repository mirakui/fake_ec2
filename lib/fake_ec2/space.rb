require 'fake_ec2'
require 'fake_ec2/model_set'

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
      @attributes[:instances] ||= ModelSet.new
    end

    def tags
      @attributes[:tags] ||= ModelSet.new
    end

    def clear
      @attributes = {}
    end

    def dump
      Marshal.dump @attributes
    end
  end
end

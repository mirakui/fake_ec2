require "fake_ec2/version"

module FakeEc2
  autoload 'IdGenerator', 'fake_ec2/id_generator'
  autoload 'IpAddrGenerator', 'fake_ec2/ip_addr_generator'

  module_function
    def id_generator
      @id_generator ||= FakeEc2::IdGenerator.new
    end

    def ip_addr_generator
      @ip_addr_generator ||= FakeEc2::IpAddrGenerator.new
    end
end

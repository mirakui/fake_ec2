require "fake_ec2/version"

module FakeEc2
  autoload 'IdGenerator', 'fake_ec2/id_generator'
  autoload 'IpAddrGenerator', 'fake_ec2/ip_addr_generator'
  autoload 'Space', 'fake_ec2/space'

  module_function
    def space
      @space ||= Space.new
    end
end

require "fake_ec2/version"

module FakeEc2
  autoload 'IdGenerator', 'fake_ec2/id_generator'
  autoload 'IpAddrGenerator', 'fake_ec2/ip_addr_generator'
  autoload 'Space', 'fake_ec2/space'
  autoload 'Model', 'fake_ec2/model'
  autoload 'HttpHandler', 'fake_ec2/http_handler'

  module_function
    def space
      @space ||= Space.new
    end
end

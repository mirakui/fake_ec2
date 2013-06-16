require "fake_ec2/version"

module FakeEc2
  autoload 'IdGenerator', 'fake_ec2/id_generator'

  module_function
    def id_generator
      @id_generator ||= FakeEc2::IdGenerator.new
    end
end

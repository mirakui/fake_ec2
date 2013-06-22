require 'fake_ec2'

module FakeEc2
  module Action
    autoload :RunInstances, 'fake_ec2/action/run_instances'

    class Base
      def space
        FakeEc2.space
      end
    end
  end
end

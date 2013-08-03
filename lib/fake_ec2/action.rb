require 'fake_ec2'

module FakeEc2
  module Action
    autoload :CreateTags, 'fake_ec2/action/create_tags'
    autoload :DescribeInstances, 'fake_ec2/action/describe_instances'
    autoload :RunInstances, 'fake_ec2/action/run_instances'

    class Base
      def space
        FakeEc2.space
      end

      def generate_result(hash)
        {
          request_id: space.id_generator.generate_request_id,
          owner_id: nil
        }.merge(hash)
      end
    end
  end
end

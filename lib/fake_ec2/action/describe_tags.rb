require 'fake_ec2/model'
require 'fake_ec2/action'

module FakeEc2
  module Action
    class DescribeTags < Base
      def run(params)
        result = generate_result(
          tag_set: space.tags.itemize
        )
        result
      end
    end
  end
end

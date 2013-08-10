require 'fake_ec2/model'
require 'fake_ec2/action'

module FakeEc2
  module Action
    class CreateTags < Base
      def run
        resource_ids = params[:resource_id]
        resource_ids.each do |resource_id|
          tags = params[:tag]
          tags.each do |tag|
            space.tags << Model::Tag.new(
              resource_id: resource_id,
              key: tag[:key],
              value: tag[:value]
            )
          end
        end
        generate_result return: 'true'
      end
    end
  end
end

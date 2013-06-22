require 'fake_ec2/model/instance'
require 'fake_ec2/action'

module FakeEc2
  module Action
    class RunInstances < Base
      def run(params)
        instances = []
        params[:max_count].to_i.times do |i|
          instances << FakeEc2::Model::Instance.new
        end
        space.instances.concat instances
        result = {
          request_id: space.id_generator.generate_request_id,
          owner_id: nil,
          group_set: nil,
          instances_set: format_instances(instances)
        }
        result
      end

      private
        def format_instances(instances)
          instances.map do |ins|
            { item: ins.to_h }
          end
        end
    end
  end
end

require 'fake_ec2/model'
require 'fake_ec2/action'

module FakeEc2
  module Action
    class RunInstances < Base
      def run(params)
        instances = Model::Set.new
        params[:max_count].to_i.times do |i|
          instances << Model::Instance.new
        end
        space.instances.concat instances
        result = generate_result(
          group_set: nil,
          instances_set: instances.itemize
        )
        instances.each do |instance|
          instance.instance_state = Model::Instance::INSTANCE_STATES[:running]
        end
        result
      end
    end
  end
end

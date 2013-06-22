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
        {
          request_id: space.id_generator.generate_request_id,
          owner_id: nil,
          group_set: nil,
          instances_set: instances.map(&:to_h)
        }
      end
    end
  end
end

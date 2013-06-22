require 'fake_ec2/model'
require 'fake_ec2/action'

module FakeEc2
  module Action
    class DescribeInstances < Base
      def run(params)
        result = generate_result(
          reservation_set: reservations.itemize
        )
        result
      end

      private
        def reservations
          set = Model::Set.new
          space.instances.group_by(&:reservation_id).map do |r_id, instances|
            set << Model::Reservation.new(
              reservation_id: r_id,
              group_set: nil,
              instances_set: Model::Set.new(instances)
            )
          end
          set
        end
    end
  end
end

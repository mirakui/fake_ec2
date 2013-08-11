require 'fake_ec2/model'
require 'fake_ec2/model_set'
require 'fake_ec2/action'

module FakeEc2
  module Action
    class DescribeInstances < Base
      include Filterable

      filters %w[
        architecture availability-zone
        block-device-mapping.attach-time block-device-mapping.delete-on-termination block-device-mapping.device-name
        block-device-mapping.status block-device-mapping.volume-id
        client-token dns-name group-id group-name image-id
        instance-id instance-lifecycle instance-state-code instance-state-name instance-type instance.group-id instance.group-name
        ip-address kernel-id key-name launch-index launch-time monitoring-state owner-id
        placement-group-name platform private-dns-name private-ip-address product-code product-code.type
        ramdisk-id reason requester-id reservation-id root-device-name root-device-type
        source-dest-check spot-instance-request-id state-reason-code state-reason-message subnet-id
        tag-key tag-value tag:key virtualization-type vpc-id hypervisor
        network-interface.description network-interface.subnet-id network-interface.vpc-id network-interface.network-interface.id
        network-interface.owner-id network-interface.availability-zone network-interface.requester-id network-interface.requester-managed
        network-interface.status network-interface.mac-address network-interface-private-dns-name network-interface.source-destination-check
        network-interface.group-id network-interface.group-name network-interface.attachment.attachment-id network-interface.attachment.instance-id
        network-interface.attachment.instance-owner-id network-interface.addresses.private-ip-address network-interface.attachment.device-index
        network-interface.attachment.status network-interface.attachment.attach-time network-interface.attachment.delete-on-termination
        network-interface.addresses.primary network-interface.addresses.association.public-ip network-interface.addresses.association.ip-owner-id
        association.public-ip association.ip-owner-id association.allocation-id association.association-id
      ]

      def run
        if params[:instance_id]
          params[:filter] ||= []
          params[:filter] << { name: 'instance-id', value: params[:instance_id] }
        end
        result = generate_result(
          reservation_set: reservations.itemize
        )
        result
      end

      private
        def reservations
          set = ModelSet.new
          instances = filter space.instances
          instances.group_by(&:reservation_id).map do |r_id, instances|
            set << Model::Reservation.new(
              reservation_id: r_id,
              group_set: nil,
              instances_set: ModelSet.new(instances)
            )
          end
          set
        end
    end
  end
end

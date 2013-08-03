require 'fake_ec2'
require 'fake_ec2/model'

module FakeEc2
  module Model
    class Tag < Base
      # customer-gateway | dhcp-options | image | instance | internet-gateway | network-acl |
      # network-interface | reserved-instances | route-table | security-group | snapshot |
      # spot-instances-request | subnet | volume | vpc | vpn-connection | vpn-gateway
      RESOURCE_TYPE_PREFIXES = Hash[*%w(
        i    instance
        ami  image
        sg   security-group
        vol  volume
        snap snapshot
        vpc  vpc
        eni  network-interface
      )].freeze

      field :resource_id
      field :key
      field :value
      field :resource_type, default: proc {
        prefix = resource_id.split('-').first
        RESOURCE_TYPE_PREFIXES[prefix]
      }
    end
  end
end

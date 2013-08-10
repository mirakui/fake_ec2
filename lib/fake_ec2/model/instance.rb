require 'fake_ec2'
require 'fake_ec2/model'
require 'fake_ec2/model_set'

module FakeEc2
  module Model
    class Instance < Base
      INSTANCE_STATES = {
        pending:       { code: 0, name: 'pending' },
        running:       { code: 16, name: 'running' },
        shutting_down: { code: 32, name: 'shutting-down' },
        terminated:    { code: 48, name: 'terminated' },
        stopping:      { code: 64, name: 'stopping' },
        stooped:       { code: 80, name: 'stopped' }
      }

      field :reservation_id
      field :owner_id

      field :instance_id,
        default: proc { FakeEc2.space.id_generator.generate_8hex('i') },
        memoize: true
      field :image_id
      field :instance_state, default: INSTANCE_STATES[:pending]
      field :reason
      field :key_name
      field :ami_launch_index, default: 0
      field :product_codes
      field :instance_type
      field :launch_time,
        default: proc { Time.now.utc.strftime('%Y-%m-%dT%H:%M:%S%z') },
        memoize: true
      field :placement
      field :platform
      field :monitoring
      field :private_ip_address,
        default: proc {
          FakeEc2.space.ip_addr_generator.generate('10.0.0.0/8')
        },
        memoize: true
      field :ip_address,
        default: proc {
          FakeEc2.space.ip_addr_generator.generate('192.0.2.0/24')
        },
        memoize: true
      field :private_dns_name,
        default: proc {
          "ip-#{private_ip_address.gsub('.', '-')}.ec2.internal"
        }
      field :dns_name,
        default: proc {
          "ec2-#{ip_address.gsub('.', '-')}.compute-1.amazonaws.com"
        }
      field :architecture, default: 'x86_64'
      field :root_device_type, default: 'ebs'
      field :root_device_name, default: '/dev/sda1'
      field :block_device_mapping
      field :virtualization_type, default: 'hvm'
      field :client_token
      field :hypervisor, default: 'xen'

      field :security_groups
      field :network_interfaces

      field :tag_set, default: proc {
        ModelSet.new FakeEc2.space.tags.select {|tag| tag.resource_id == instance_id }
      }
    end
  end
end

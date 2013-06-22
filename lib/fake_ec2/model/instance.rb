require 'fake_ec2'
require 'fake_ec2/model'

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

      field :instance_id, default: -> { FakeEc2.space.id_generator.generate_8hex('i') }
      field :image_id
      field :instance_state, default: INSTANCE_STATES[:pending]
      field :reason
      field :key_name
      field :ami_launch_index, default: 0
      field :product_codes
      field :instance_type
      field :launch_time, default: -> { Time.now.utc.strftime('%Y-%m-%dT%H:%M:%S%z') }
      field :placement
      field :platform
      field :monitoring
      field :private_ip_address, default: -> {
        FakeEc2.space.ip_addr_generator.generate('10.0.0.0/8')
      }
      field :ip_address, default: -> {
        FakeEc2.space.ip_addr_generator.generate('192.0.2.0/24')
      }
      field :private_dns_name, default: ->(this) {
        "ip-#{this.private_ip_address.gsub('.', '-')}.ec2.internal"
      }
      field :dns_name, default: ->(this) {
        "ec2-#{this.ip_address.gsub('.', '-')}.compute-1.amazonaws.com"
      }
      field :architecture, default: 'x86_64'
      field :root_device_type, default: 'ebs'
      field :root_device_name, default: '/dev/sda1'
      field :block_device_mapping
      field :virtualization_type, default: 'hvm'
      field :client_token
      field :hypervisor, default: 'xen'

      field :security_groups
      field :tags
      field :network_interfaces
    end
  end
end
__END__
              <instanceId>i-2a2b3c4d</instanceId>
              <imageId>ami-2a2b3c4d</imageId>
              <instanceState>
                <code>16</code>
                <name>running</name>
              </instanceState>
              <privateDnsName>ip-10-251-50-35.ec2.internal</privateDnsName>
              <dnsName>ec2-67-202-51-223.compute-1.amazonaws.com</dnsName>
              <reason/>
              <keyName>gsg-keypair</keyName>
              <amiLaunchIndex>0</amiLaunchIndex>
              <productCodes/>
              <instanceType>t1.micro</instanceType>
              <launchTime>YYYY-MM-DDTHH:MM:SS+0000</launchTime>
              <placement>
                <availabilityZone>us-west-2b</availabilityZone>
                <groupName/>
                <tenancy>default</tenancy>
              </placement>
              <platform>windows</platform>
              <monitoring>
                <state>disabled</state>
              </monitoring>
              <privateIpAddress>10.139.34.251</privateIpAddress>
              <ipAddress>122.248.233.255</ipAddress>
              <groupSet>
                <item>
                  <groupId>sg-2a2b3c4d</groupId>
                  <groupName>my-security-group-2</groupName>
                </item>
              </groupSet>
              <architecture>x86_64</architecture>
              <rootDeviceType>ebs</rootDeviceType>
              <rootDeviceName>/dev/sda1</rootDeviceName>
              <blockDeviceMapping>
                <item>
                  <deviceName>/dev/sda1</deviceName>
                  <ebs>
                    <volumeId>vol-2a2b3c4d</volumeId>
                    <status>attached</status>
                    <attachTime>YYYY-MM-DDTHH:MM:SS.SSSZ</attachTime>
                    <deleteOnTermination>true</deleteOnTermination>
                  </ebs>
                </item>
              </blockDeviceMapping>
              <virtualizationType>hvm</virtualizationType>
              <clientToken>ABCDE1234567890123</clientToken>
              <tagSet>
                <item>
                  <key>Name</key>
                  <value>EC2 Instance</value>
                </item>
              </tagSet>
              <hypervisor>xen</hypervisor>
              <networkInterfaceSet/>

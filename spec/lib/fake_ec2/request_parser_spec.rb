require 'spec_helper'
require 'fake_ec2/request_parser'

describe FakeEc2::RequestParser do
  describe '#parse RunInstances' do
    subject do
      described_class.parse %w[
        ?Action=RunInstances
        &ImageId=ami-beb0caec
        &InstanceType=m1.large
        &MaxCount=1
        &MinCount=1
        &Monitoring.Enabled=false
        &NetworkInterface.0.DeviceIndex=0
        &NetworkInterface.0.PrivateIpAddresses.0.Primary=true
        &NetworkInterface.0.PrivateIpAddresses.0.PrivateIpAddress=10.0.2.106
        &NetworkInterface.0.PrivateIpAddresses.1.Primary=false
        &NetworkInterface.0.PrivateIpAddresses.1.PrivateIpAddress=10.0.2.107
        &NetworkInterface.0.PrivateIpAddresses.2.Primary=false
        &NetworkInterface.0.PrivateIpAddresses.2.PrivateIpAddress=10.0.2.108
        &NetworkInterface.0.SubnetId=subnet-a61dafcf
      ].join
    end

    it do
      is_expected.to match(
        :action => "RunInstances",
        :image_id => "ami-beb0caec",
        :instance_type => "m1.large",
        :max_count => "1",
        :min_count => "1",
        :monitoring => { :enabled => "false" },
        :network_interface => [
          { :device_index => "0", :private_ip_addresses => [
            { :primary => "true",  :private_ip_address => "10.0.2.106" },
            { :primary => "false", :private_ip_address => "10.0.2.107" },
            { :primary => "false", :private_ip_address => "10.0.2.108" }
          ],
          :subnet_id => "subnet-a61dafcf"}
        ]
      )
    end
  end

  describe '#parse CreateTags' do
    subject do
      described_class.parse %w[
        Action=CreateTags
        &ResourceId.1=i-0123
        &ResourceId.2=ami-0123
        &Tag.1.Key=Name
        &Tag.1.Value=host0
        &Tag.2.Key=Role
        &Tag.2.Value=role0
      ].join
    end

    it do
      is_expected.to match(
        action: 'CreateTags',
        resource_id: %w[i-0123 ami-0123],
        tag: [
          { key: 'Name', value: 'host0'},
          { key: 'Role', value: 'role0'}
        ]
      )
    end
  end
end

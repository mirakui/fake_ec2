require 'spec_helper'
require 'fake_ec2/request_parser'

describe FakeEc2::RequestParser do
  describe '#parse' do
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

    it { should ==
      { :action => "RunInstances",
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
      }
    }
  end
end

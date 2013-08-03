require 'spec_helper'
require 'aws-sdk'
require 'fake_ec2'

describe 'AWS::Ec2 handler' do
  let(:ec2) do
    AWS::EC2.new http_handler: FakeEc2::HttpHandler.new
  end

  before do
    FakeEc2.space.clear
  end

  describe 'RunInstances and DescribeInstances' do
    specify do
      ec2.instances.create image_id: 'ami-001', count: 2
      ec2.instances.to_a.should have(2).instances
    end
  end

  describe 'Tags' do
    before(:all) do
      ec2.instances.create image_id: 'ami-001', count: 2
      ec2.instances.each_with_index do |ins, i|
        ins.tags.set 'Name' => "host#{i}", 'Role' => "role#{i}"
      end
    end

    it { expect(ec2.instances[0].tags['Name']).to eq('host0') }
    it { expect(ec2.instances[0].tags['Role']).to eq('role0') }
    it { expect(ec2.instances[1].tags['Name']).to eq('host1') }
    it { expect(ec2.instances[1].tags['Role']).to eq('role1') }
  end
end

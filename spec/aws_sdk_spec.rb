require 'spec_helper'
require 'aws-sdk'
require 'fake_ec2/http_handler'

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
end

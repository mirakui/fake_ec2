require 'spec_helper'
require 'aws-sdk-v1'
require 'fake_ec2'

describe 'AWS::Ec2 handler' do
  let(:ec2) do
    AWS::EC2.new http_handler: FakeEc2::HttpHandler.new
  end
  let(:space) { FakeEc2.space }

  before do
    FakeEc2.space.clear
  end

  describe 'RunInstances and DescribeInstances' do
    before { ec2.instances.create image_id: 'ami-001', count: 2 }
    it { expect(ec2.instances.count).to eq 2 }
  end

  describe 'Tags' do
    let!(:instance1) do
      ins = ec2.instances.create image_id: 'ami-001'
      ins.tags.set 'Key1' => 'Value1', 'Key2' => 'Value2'
      ins
    end
    let!(:instance2) do
      ins = ec2.instances.create image_id: 'ami-002'
      ins.tags.set 'Key3' => 'Value3', 'Key4' => 'Value4'
      ins
    end

    it { expect(instance1.tags['Key1']).to eq 'Value1' }
    it { expect(instance1.tags['Key2']).to eq 'Value2' }

    context 'with DescribeTags' do
      subject!(:result) do
        ec2.client.describe_tags(
          filters: [{ name: 'resource-id', values: [instance1.instance_id]}]
        )
      end

      it { expect(result[:tag_set][0][:key]).to eq 'Key1' }
      it { expect(result[:tag_set][0][:value]).to eq 'Value1' }
      it { expect(result[:tag_set][1][:key]).to eq 'Key2' }
      it { expect(result[:tag_set][1][:value]).to eq 'Value2' }
    end

    context 'with DescribeInstances' do
      subject!(:result) do
        ec2.client.describe_instances(
          filters: [{ name: 'instance-id', values: [instance1.instance_id]}]
        )
      end
      let(:instances_set) { result[:reservation_set][0][:instances_set] }
      let(:tag_set) { instances_set[0][:tag_set] }

      it { expect(tag_set[0][:key]).to eq 'Key1' }
      it { expect(tag_set[0][:value]).to eq 'Value1' }
      it { expect(tag_set[1][:key]).to eq 'Key2' }
      it { expect(tag_set[1][:value]).to eq 'Value2' }
    end

    # context 'filtering with Tags (1)' do
    #   subject!(:result) do
    #     ec2.instances.tagged('Key2').tagged_values('Value2')
    #   end
    #
    #   it { expect(result.count).to eq 1 }
    #   it { expect(result.to_a[0].tags['Key1']).to eq 'Value1' }
    #   it { expect(result.to_a[0].id).to eq instance1.id }
    # end
    #
    # context 'filtering with Tags (2)', pending: true do
    #   subject!(:result) do
    #     ec2.client.describe_instances(
    #       filters: [{ name: 'tag:Key2', values: ['Value2'] }]
    #     )
    #   end
    #
    #   pending '"tag:key" filter has not been implemented yet' do
    #     it { expect(result.count).to eq 1 }
    #     it { expect(result.to_a[0].tags['Key1']).to eq 'Value1' }
    #     it { expect(result.to_a[0].id).to eq instance1.id }
    #   end
    # end
  end
end

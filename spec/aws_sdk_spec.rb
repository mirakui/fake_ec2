require 'spec_helper'
require 'aws-sdk'
require 'fake_ec2'
require 'fake_ec2/http_handler'

describe 'Aws::EC2 handler' do
  let!(:client) do
    Aws::EC2::Client.new.tap do |client|
      client.handlers.add FakeEc2::SeahorsePlugin::Handler
    end
  end
  let(:space) { FakeEc2.space }

  before do
    FakeEc2.space.clear
  end

  describe 'RunInstances and DescribeInstances' do
    it do
      client.run_instances image_id: 'ami-001', min_count: 2, max_count: 2
      expect(client.describe_instances.instances.count).to eq 2
    end
  end

  describe 'Tags' do
    let!(:instance1) do
      res = client.run_instances image_id: 'ami-001', min_count: 1, max_count: 1
      ins = res.reservations[0].instances[0]
      client.create_tags resources: [ins.instance_id], tags: [{ key: 'Key1', value: 'Value1' }, { key: 'Key2', value: 'Value2' }]
      ins
    end
    let!(:instance2) do
      res = client.instances.create image_id: 'ami-002', min_count: 1, max_count: 1
      ins = res.reservations[0].instances[0]
      client.create_tags resources: [ins.instance_id], tags: [{ key: 'Key3', value: 'Value3' }, { key: 'Key4', value: 'Value4' }]
      ins
    end

    it { expect(instance1.tags['Key1']).to eq 'Value1' }
    it { expect(instance1.tags['Key2']).to eq 'Value2' }

    context 'with DescribeTags' do
      subject!(:result) do
        client.describe_tags(
          filters: [{ name: 'resource-id', values: [instance1.instance_id]}]
        ).reservations[0]
      end

      it { expect(result[:tag_set][0][:key]).to eq 'Key1' }
      it { expect(result[:tag_set][0][:value]).to eq 'Value1' }
      it { expect(result[:tag_set][1][:key]).to eq 'Key2' }
      it { expect(result[:tag_set][1][:value]).to eq 'Value2' }
    end

    context 'with DescribeInstances' do
      subject!(:result) do
        client.describe_instances(
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

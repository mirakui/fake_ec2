require 'spec_helper'
require 'fake_ec2/xml_builder'

describe FakeEc2::XmlBuilder do
  describe '#build_root' do
    let(:hash) do
      {
        RunInstancesResponse: {
          request_id: '1234',
          group_set: nil,
          instances_set: [
            {
              item: {
                instance_id: 'i-001'
              }
            },
            {
              item: {
                instance_id: 'i-002'
              }
            }
          ]
        }
      }
    end

    subject { described_class.new.build_root hash, xmlns: 'http://ec2.amazonaws.com/doc/2013-02-01/' }

    it { is_expected.to eq <<-END.chomp }
<?xml version="1.0" encoding="UTF-8"?>
<RunInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2013-02-01/">
    <requestId>1234</requestId>
    <groupSet/>
    <instancesSet>
        <item>
            <instanceId>i-001</instanceId>
        </item>
        <item>
            <instanceId>i-002</instanceId>
        </item>
    </instancesSet>
</RunInstancesResponse>
    END
  end
end

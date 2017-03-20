require 'spec_helper'
require 'fake_ec2/request'
describe FakeEc2::Request do
  context 'Action=RunInstances' do
    before do
      FakeEc2.space.clear
    end

    let(:request) do
      described_class.from_query_string '?Action=RunInstances&MinCount=3&MaxCount=3'
    end

    it { expect(request.action_class).to eq FakeEc2::Action::RunInstances }

    describe '#run_action' do
      subject { request.run_action }

      it { is_expected.to match /\A#{Regexp.escape('<?xml version="1.0" encoding="UTF-8"?>')}/ }
      it { is_expected.to match %r(^<RunInstancesResult xmlns="http://ec2\.amazonaws\.com/doc/2013-02-01/">.*</RunInstancesResult>)m }
      it { expect(subject.scan(%r(<instanceId>i-[0-9a-f]{8}</instanceId>)).length).to eq 3 }
    end
  end
end

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
    subject { request }

    its(:action_class) { should == FakeEc2::Action::RunInstances }
    its(:action) { should be_an_instance_of FakeEc2::Action::RunInstances }

    describe '#run_action' do
      subject { request.run_action }

      it { should =~ /\A#{Regexp.escape('<?xml version="1.0" encoding="UTF-8"?>')}/ }
      it { should =~ %r(^<RunInstancesResult xmlns="http://ec2\.amazonaws\.com/doc/2013-02-01/">.*</RunInstancesResult>)m }
      specify { subject.scan(%r(<instanceId>i-[0-9a-f]{8}</instanceId>)).should have(3).matches }
    end
  end
end

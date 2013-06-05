require 'spec_helper'
require 'fake_ec2'
require 'fake_ec2/api'

describe FakeEc2::Api do
  let(:api) { described_class.new }
  it do
    api.descrbe_instances.should be_a(String)
  end
end

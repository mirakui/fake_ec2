require 'spec_helper'
require 'fake_ec2/ip_addr_generator'

describe FakeEc2::IpAddrGenerator do
  let!(:generator) { FakeEc2::IpAddrGenerator.new }
  before { generator.reset! }

  describe '#generate' do
    specify do
      generator.generate('10.0.0.0/17').should == '10.0.0.1'
      generator.generate('10.0.0.0/17').should == '10.0.0.2'
      generator.generate('10.0.0.0/17').should == '10.0.0.3'
    end

    specify do
      generator.generate('10.0.0.0/17').should be_a(String)
    end

    it 'do not generate invalid ip address like 10.0.0.255' do
      254.times do
        generator.generate('10.0.0.0/17')
      end
      generator.generate('10.0.0.0/17').should == '10.0.1.1'
    end

    it 'runs out CIDR' do
      generator.generate('10.0.0.0/31').should == '10.0.0.1'
      expect {
        generator.generate('10.0.0.0/31')
      }.to raise_error
    end
  end
end

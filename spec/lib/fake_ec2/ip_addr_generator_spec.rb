require 'spec_helper'
require 'fake_ec2/ip_addr_generator'

describe FakeEc2::IpAddrGenerator do
  let!(:generator) { FakeEc2::IpAddrGenerator.new }
  before { generator.clear }

  describe '#generate' do
    it 'increments ip address' do
      expect(generator.generate('10.0.0.0/17')).to eq '10.0.0.1'
      expect(generator.generate('10.0.0.0/17')).to eq '10.0.0.2'
      expect(generator.generate('10.0.0.0/17')).to eq '10.0.0.3'
    end

    it 'does not generate invalid ip address like 10.0.0.255' do
      254.times do
        generator.generate('10.0.0.0/17')
      end
      expect(generator.generate('10.0.0.0/17')).to eq '10.0.1.1'
    end

    it 'runs out CIDR' do
      expect(generator.generate('10.0.0.0/31')).to eq '10.0.0.1'
      expect {
        generator.generate('10.0.0.0/31')
      }.to raise_error RuntimeError
    end
  end
end

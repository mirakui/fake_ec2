require 'spec_helper'
require 'fake_ec2/serializable'

describe FakeEc2::Serializable do
  specify do
    class Cls
      include FakeEc2::Serializable
      serializable :attr
      attr_reader :attr
      def initialize(value)
        @attr = value
        @dummy_proc = -> { "Proc is not serializable" }
      end
    end

    clone = nil
    expect {
      dump = Marshal.dump Cls.new('value1')
      clone = Marshal.load(dump)
    }.not_to raise_error

    expect(clone.attr).to eq 'value1'
  end
end

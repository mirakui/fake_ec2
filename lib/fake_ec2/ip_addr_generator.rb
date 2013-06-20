require 'fake_ec2/serializable'
require 'ipaddr'

module FakeEc2
  class IpAddrGenerator
    include Serializable
    serializable :counters

    def initialize
      @mutex = Mutex.new
      clear
    end

    def clear
      @counters = {}
    end

    def generate(cidr, key=nil)
      key ||= cidr
      @mutex.synchronize do
        IPAddr.new(cidr).to_range.each_with_index do |ip, i|
          next if i <= @counters[key].to_i
          next if ip.to_s =~ /\.(0|255)$/
          @counters[key] = i
          return ip.to_s
        end
        raise RuntimeError, "CIDR #{key} runs out"
      end
    end
  end
end

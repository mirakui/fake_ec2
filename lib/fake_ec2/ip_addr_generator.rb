require 'ipaddr'
module FakeEc2
  class IpAddrGenerator
    def initialize
      @mutex = Mutex.new
      reset!
    end

    def reset!
      @counters = Hash.new {|h, k| h[k] = 0 }
    end

    def generate(cidr, key=nil)
      key ||= cidr
      @mutex.synchronize do
        IPAddr.new(cidr).to_range.each_with_index do |ip, i|
          next if i <= @counters[key]
          next if ip.to_s =~ /\.(0|255)$/
          @counters[key] = i
          return ip.to_s
        end
        raise RuntimeError, "CIDR #{key} runs out"
      end
    end
  end
end

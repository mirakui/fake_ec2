require 'set'
module FakeEc2
  class IdGenerator
    attr_reader :generated_ids

    def initialize
      @mutex = Mutex.new
      reset!
    end

    def reset!
      @generated_ids = {}
    end

    def generate_8hex(prefix)
      generate_uniquely(prefix.to_s) do
        "#{prefix}-%08x" % rand(16**8)
      end
    end

    def generate_request_id
      generate_uniquely('request_id') do
        "%08x-%04x-%04x-%04x-%012x" % (
          [8, 4, 4, 4, 12].map {|i| rand(16**i) }
        )
      end
    end

    private
      def generate_uniquely(key)
        @mutex.synchronize do
          @generated_ids[key] ||= Set.new
          begin
            id = yield
          end while @generated_ids[key].include?(id)
          @generated_ids[key] = id
        end
      end
  end
end

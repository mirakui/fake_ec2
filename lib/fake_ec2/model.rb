module FakeEc2
  module Model
    class Base
      def initialize(params={})
        self.class.fields.each do |key, options|
          value = params[key] ? params[key] : options[:default]
          instance_variable_set("@#{key}", value)
        end
        # process lazy evaluations
        self.class.fields.each do |key, options|
          attr = instance_variable_get("@#{key}")
          next unless attr.is_a?(Proc)
          value = case attr.arity
                  when 0
                    attr.call
                  when 1
                    attr.call(self)
                  end
          instance_variable_set("@#{key}", value)
        end
      end

      class << self
        attr_reader :fields

        def field(name, options={})
          attr_accessor name
          @fields ||= {}
          @fields[name] = options
        end
      end
    end
  end
end

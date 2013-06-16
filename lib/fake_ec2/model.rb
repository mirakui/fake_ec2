module FakeEc2
  module Model
    class Base
      def initialize(params={})
        self.class.fields.each do |key, options|
          value = params[key] ? params[key] :
            (options[:default].is_a?(Proc) ? options[:default].call : options[:default])
          instance_variable_set("@#{key}", value)
        end
      end

      class << self
        attr_reader :fields

        def field(name, options)
          attr_accessor name
          @fields ||= {}
          @fields[name] = options
        end
      end
    end
  end
end

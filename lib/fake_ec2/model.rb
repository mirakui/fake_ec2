require 'fake_ec2/serializable'

module FakeEc2
  module Model
    class Base
      include Serializable
      serializable :fields

      def initialize(params={})
        @fields = {}
      end

      def to_h
        apply_defaults
        @fields
      end

      def apply_defaults
        self.class.field_config.each do |name, _|
          @fields[name] ||= default_value(name)
        end
      end

      def default_value(name)
        default = self.class.field_config[name][:default]
        if default.is_a?(Proc)
          case default.arity
          when 0
            default.call
          when 1
            default.call(self)
          end
        else
          default
        end
      end

      class << self
        attr_reader :field_config

        def field(name, options={})
          @field_config ||= {}
          @field_config[name.to_sym] = options

          methods = <<-END
def #{name}=(obj)
  @fields[:#{name}] = obj
end
          END
          if options[:default]
            methods += <<-END
def #{name}
  @fields[:#{name}] || default_value(:#{name})
end
            END
          else
            methods += <<-END
def #{name}
  @fields[:#{name}]
end
            END
          end
          class_eval methods
        end
      end
    end
  end
end

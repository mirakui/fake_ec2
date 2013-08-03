require 'fake_ec2/serializable'

module FakeEc2
  module Model
    autoload :Instance, 'fake_ec2/model/instance'
    autoload :Reservation, 'fake_ec2/model/reservation'
    autoload :Tag, 'fake_ec2/model/tag'

    class Base
      include Serializable
      serializable :fields
      attr_reader :fields
      protected :fields

      def initialize(fields={})
        @fields = fields
      end

      def initialize_copy(other)
        @fields = other.fields.dup
      end

      def to_h
        clone = self.dup
        clone.apply_defaults
        clone.fields
      end
      alias_method :itemize, :to_h

      def apply_defaults
        self.class.field_config.each do |name, options|
          @fields[name] ||= default_value(name)
        end
      end

      def default_value(name)
        default = self.class.field_config[name][:default]
        if default.is_a?(Proc)
          self.instance_eval &default
        else
          default
        end
      end

      def itemize
        hash = {}
        to_h.each do |key, value|
          hash[key] = value.respond_to?(:itemize) ? value.itemize : value
        end
        hash
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

    class Set < Array
      def initialize(items=[])
        self.replace(items) if items
      end

      def itemize
        map do |item|
          { item: item.respond_to?(:itemize) ? item.itemize : item }
        end
      end
    end
  end
end

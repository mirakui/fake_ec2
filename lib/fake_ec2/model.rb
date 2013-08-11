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
        apply_defaults
      end

      def initialize_copy(other)
        @fields = other.fields.dup
      end

      def to_h
        hash = {}
        self.class.field_config.each do |name, options|
          hash[name] = if @fields[name]
                         @fields[name]
                       elsif options[:default]
                         default_value(name)
                       else
                         nil
                       end
        end
        hash
      end
      alias_method :itemize, :to_h

      def apply_defaults
        self.class.field_config.each do |name, options|
          if !options[:default].is_a?(Proc) || options[:memoize]
            @fields[name] ||= default_value(name)
          end
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

      def pass?(value, &block)
        bind_proc(&block).call value
      end

      def bind_proc(&block)
        name = '__bind_proc__'
        self.class.class_eval do
          define_method(name, &block)
          method = instance_method(name)
          remove_method(name)
          method
        end.bind(self)
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
            if options[:memoize]
              methods += <<-END
def #{name}
  @fields[:#{name}] ||= default_value(:#{name})
end
              END
            else
              methods += <<-END
def #{name}
  @fields[:#{name}] || default_value(:#{name})
end
              END
            end
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

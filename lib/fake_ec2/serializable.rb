module FakeEc2
  module Serializable
    def marshal_dump
      attr_name = self.class.serializable_attribute_name
      instance_variable_get("@#{attr_name}")
    end

    def marshal_load(obj)
      attr_name = self.class.serializable_attribute_name
      instance_variable_set("@#{attr_name}", obj)
    end

    def self.included(cls)
      cls.extend(ClassMethods)
    end

    module ClassMethods
      attr_reader :serializable_attribute_name
      def serializable(attr_name)
        @serializable_attribute_name = attr_name
      end
    end
  end
end

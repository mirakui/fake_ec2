require 'fake_ec2'

module FakeEc2
  module Action
    autoload :CreateTags, 'fake_ec2/action/create_tags'
    autoload :DescribeTags, 'fake_ec2/action/describe_tags'
    autoload :DescribeInstances, 'fake_ec2/action/describe_instances'
    autoload :RunInstances, 'fake_ec2/action/run_instances'

    class Base
      attr_reader :params

      def space
        FakeEc2.space
      end

      def initialize(params={})
        @params = params
      end

      def run
        raise NotImplementError
      end

      def generate_result(hash)
        {
          request_id: space.id_generator.generate_request_id,
          owner_id: nil
        }.merge(hash)
      end
    end

    module Filterable
      def self.included(cls)
        cls.extend ClassMethods
      end

      def filter(set)
      end

      def generate_filter(filter_params)
        filter_action_class = self.class
        proc do |action|
          filter_passed = true
          filter_action_class.filter_procs.each do |name, block|
            filter_param = filter_params.find {|param| param[:name] == name }
            next if !filter_param || !filter_param[:value]
            filter_param[:value].each do |value|
              any_values_passed = false
              #binding.pry
              #self.instance_eval do
              #  any_values_passed = true if block.call(value)
              #end
              #self.instance_eval(&(block.curry(2)[value]))
              self.pass?(name, &block)
              filter_passed = false unless any_values_passed
              break unless filter_passed
            end
            break unless filter_passed
          end
          filter_passed
        end
      end

      module ClassMethods
        def filters(names, &block)
          names.each {|name| filter(name, &block) }
        end

        def filter(name, &block)
          @filter_procs ||= []
          unless block_given?
            block = proc {|value| self.__send__(name.gsub('-', '_')) == value }
          end
          @filter_procs << [name, block]
        end

        def filter_procs
          @filter_procs
        end
      end
    end
  end
end

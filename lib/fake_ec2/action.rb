require 'fake_ec2'
require 'fake_ec2/model_set'

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
        return set unless params[:filter]
        self.class.filter_procs.each do |name, block|
          filter_param = params[:filter].find {|param| param[:name] == name }
          next if !filter_param || !filter_param[:value]
          set = ModelSet.new(
            filter_param[:value].map {|value|
              set.filter {|model| model.pass? value, &block }
            }.flatten.uniq
          )
        end
        set
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

require 'fake_ec2/request_parser'
require 'fake_ec2/action'
module FakeEc2
  class Request
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def self.from_param_string(param_string)
      new FakeEc2::RequestParser.parse(param_string)
    end

    def action_class
      action = params[:action]
      if action !~ /^[A-Z][a-zA-Z]*$/ || !FakeEc2::Action.const_defined?(action)
        raise ArgumentError, "unexpected action: #{action}"
      end
      FakeEc2::Action.const_get action
    end

    def action
      @action ||= action_class.new
    end

    def run_action
      action.run self.params
    end
  end
end

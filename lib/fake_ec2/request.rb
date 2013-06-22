require 'fake_ec2/request_parser'
require 'fake_ec2/action'
require 'fake_ec2/xml_builder'

module FakeEc2
  class Request
    RESPONSE_XMLNS = 'http://ec2.amazonaws.com/doc/2013-02-01/'
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def self.from_query_string(query_string)
      new RequestParser.parse(query_string)
    end

    def action_class
      action = params[:action]
      if action !~ /^[A-Z][a-zA-Z]*$/ || !Action.const_defined?(action)
        raise ArgumentError, "unexpected action: #{action}"
      end
      Action.const_get action
    end

    def action
      @action ||= action_class.new
    end

    def run_action
      result = action.run(self.params)
      root = { "#{params[:action].to_s}Result" => result }
      builder = XmlBuilder.new
      builder.build_root root, xmlns: RESPONSE_XMLNS
    end
  end
end

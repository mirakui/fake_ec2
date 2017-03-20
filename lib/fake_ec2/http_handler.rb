require 'seahorse'
require 'fake_ec2/request'

module FakeEc2
  class SeahorsePlugin < Seahorse::Client::Plugin
    class Handler < Seahorse::Client::Handler
      def call(context)
        fake_request = Request.from_param_list context.http_request.body.param_list
        response_body = fake_request.run_action
        resp = Seahorse::Client::Http::Response.new status_code: 200, body: response_body
        context.http_response = resp
        res = Seahorse::Client::Response.new context: context
      end
    end

    handler(Handler)
  end
end

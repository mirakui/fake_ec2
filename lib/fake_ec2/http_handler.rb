module FakeEc2
  class HttpHandler
    def handle(request, response, &read_block)
      fake_request = fake_request request
      body = fake_request.run_action
      if block_given?
        body.each_line do |line|
          read_block.call line
        end
      else
        response.body = body
      end
    end

    private
      def fake_request(http_request)
        Request.from_query_string http_request.body
      end
  end
end

require 'spec_helper'
require 'fake_ec2/http_handler'

describe FakeEc2::HttpHandler do
  let!(:handler) do
    described_class.new.tap do |h|
      h.stub(:fake_request) do
        double run_action: "multiple\nline\nbody"
      end
    end
  end
  let(:request) do
    double body: ''
  end

  let(:response) do
    Struct.new(:status, :headers, :body).new status: 200, headers: {}
  end

  describe '#handle with block' do
    specify do
      body = ''
      handler.handle(request, response) do |str|
        body += str
      end
      body.should == "multiple\nline\nbody"
    end
  end

  describe '#handle without block' do
    specify do
      handler.handle(request, response).should == "multiple\nline\nbody"
      response.body.should == "multiple\nline\nbody"
    end
  end
end

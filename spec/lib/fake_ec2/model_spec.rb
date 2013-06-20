require 'spec_helper'
require 'fake_ec2/model'

describe FakeEc2::Model do
  specify do
    class MyModel < FakeEc2::Model::Base
      field :hello, default: ->(this) { "My name is #{this.name}. I'm #{this.age} years old." }
      field :name, default: 'alice'
      field :age
    end

    model = MyModel.new
    model.age = 18
    model.hello.should == "My name is alice. I'm 18 years old."
  end
end

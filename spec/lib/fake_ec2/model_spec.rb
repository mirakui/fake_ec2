require 'spec_helper'
require 'fake_ec2/model'

describe FakeEc2::Model do
  class MyModel < FakeEc2::Model::Base
    field :name, default: 'alice'
    field :age
    field :hello, default: ->(this) { "My name is #{this.name}. I'm #{this.age} years old." }
  end

  specify do
    model = MyModel.new
    model.age = 18
    model.hello.should == "My name is alice. I'm 18 years old."
  end

  specify do
    model = MyModel.new
    model.age = 18
    model.to_h.should include(
      hello: "My name is alice. I'm 18 years old.",
      name:  'alice',
      age:   18
    )
  end
end

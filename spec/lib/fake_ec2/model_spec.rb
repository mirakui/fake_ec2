require 'spec_helper'
require 'fake_ec2/model'

describe FakeEc2::Model do
  class MyModel < FakeEc2::Model::Base
    field :name, default: 'alice'
    field :age
    field :hello, default: ->(this) { "My name is #{this.name}. I'm #{this.age} years old." }
  end

  describe MyModel do
    subject! do
      MyModel.new.tap do |model|
        model.age = 18
      end
    end

    its(:hello) { should == "My name is alice. I'm 18 years old." }
    its(:to_h) do
      should include(
        hello: "My name is alice. I'm 18 years old.",
        name:  'alice',
        age:   18
      )
    end
  end

  describe FakeEc2::Model::Set do
    subject! do
      FakeEc2::Model::Set.new.tap do |set|
        set << MyModel.new(age: 18)
        set << MyModel.new(age: 19)
        set << MyModel.new(age: 20)
      end
    end

    it { should have(3).items }
    specify { subject.select {|model| model.age >= 19 }.should have(2).items }
    specify { subject.itemize.first[:item].should be_a(Hash) }
  end
end

require 'spec_helper'
require 'fake_ec2/model'

describe FakeEc2::Model do
  class MyModel < FakeEc2::Model::Base
    field :name, default: 'alice'
    field :age
    field :hello, default: proc { "My name is #{name}. I'm #{age} years old." }
    field :random, default: proc { rand.to_s }, memoize: true
  end

  describe MyModel do
    subject!(:model) do
      MyModel.new.tap do |model|
        model.age = 18
      end
    end

    it { subject.hello.should == "My name is alice. I'm 18 years old." }
    it { subject.name.should == 'alice' }
    it { subject.age.should == 18 }

    describe '#to_h' do
      it do
        expect { model.age = 20 }.to change { model.to_h[:hello] }.
          from("My name is alice. I'm 18 years old.").
          to("My name is alice. I'm 20 years old.")
      end
    end

    describe 'memoized fields' do
      it { expect {}.not_to change { model.random } }
    end
  end
end

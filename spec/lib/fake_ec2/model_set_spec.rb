require 'spec_helper'
require 'fake_ec2/model'
require 'fake_ec2/model_set'

describe FakeEc2::ModelSet do
  class MyModel < FakeEc2::Model::Base
    field :name, default: 'alice'
    field :age
    field :hello, default: proc { "My name is #{name}. I'm #{age} years old." }
    field :random, default: proc { rand.to_s }, memoize: true
  end

  subject!(:set) do
    FakeEc2::ModelSet.new.tap do |set|
      set << MyModel.new(name: 'Alice', age: 18)
      set << MyModel.new(name: 'Bob',   age: 19)
      set << MyModel.new(name: 'Carol', age: 20)
    end
  end

  it { subject.length.should == 3 }
  specify { subject.select {|model| model.age >= 19 }.length.should == 2 }
  specify { subject.itemize.first[:item].should be_a(Hash) }

  describe '#filter' do
    subject!(:filtered_result) do
      set.filter { age == 19 }
    end

    it { subject.length.should == 1 }
    it { expect(filtered_result.first.name).to eq('Bob') }
  end
end

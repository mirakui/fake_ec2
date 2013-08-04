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

    its(:hello) { should == "My name is alice. I'm 18 years old." }
    its(:to_h) do
      should include(
        hello: "My name is alice. I'm 18 years old.",
        name:  'alice',
        age:   18
      )
    end

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

  describe FakeEc2::Model::Set do
    subject!(:set) do
      FakeEc2::Model::Set.new.tap do |set|
        set << MyModel.new(name: 'Alice', age: 18)
        set << MyModel.new(name: 'Bob',   age: 19)
        set << MyModel.new(name: 'Carol', age: 20)
      end
    end

    it { should have(3).items }
    specify { subject.select {|model| model.age >= 19 }.should have(2).items }
    specify { subject.itemize.first[:item].should be_a(Hash) }

    describe '#filter' do
      subject!(:filtered_result) do
        set.filter { age == 19 }
      end

      its(:length) { should == 1 }
      it { expect(filtered_result.first.name).to eq('Bob') }
    end
  end
end

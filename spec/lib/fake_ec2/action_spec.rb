require 'spec_helper'
require 'fake_ec2/model'
require 'fake_ec2/action'

describe FakeEc2::Action::Filterable do
  class ModelA < FakeEc2::Model::Base
    field :name
    field :user_id
    field :age
    field :gender
    field :place
  end

  class DescribeA < FakeEc2::Action::Base
    include FakeEc2::Action::Filterable

    filters %w[name user-id gender place]
    filter('years-old') {|v| self.age == v }
    filters(%w[foo bar]) { raise NotImplementedError }

    def initialize(params, set)
      @set = set
      super params
    end

    def run
      set = filter @set
      generate_result(
        result_set: set.itemize
      )
    end
  end

  let(:set) do
    set = FakeEc2::ModelSet.new
    set << ModelA.new(name: 'Alice', user_id: 1, age: 20, gender: 'female', place: 'Tokyo')
    set << ModelA.new(name: 'Bob',   user_id: 2, age: 22, gender: 'male',   place: 'Nagoya')
    set << ModelA.new(name: 'Carol', user_id: 3, age: 24, gender: 'female', place: 'Nagoya')
    set
  end

  context 'run with filtering (1)' do
    let(:params) do
      {
        filter: [
          {name: 'place', value: ['Tokyo', 'Osaka']},
          {name: 'gender', value: ['female']}
        ]
      }
    end
    let(:action) do
      DescribeA.new params, set
    end
    subject!(:result) do
      action.run
    end
    it { expect(result[:result_set]).to have(1).item }
    it { expect(result[:result_set][0][:item][:name]).to eq('Alice') }
  end
end

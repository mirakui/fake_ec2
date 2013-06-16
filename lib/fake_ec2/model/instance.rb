require 'fake_ec2'
require 'fake_ec2/model'

module FakeEc2
  module Model
    class Instance < Base
      field :instance_id, default: -> { FakeEc2.id_generator.generate_8hex('i') }
      field :instance_state, default: { code: 0, name: 'pending' }
    end
  end
end

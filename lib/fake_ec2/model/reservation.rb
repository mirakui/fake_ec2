require 'fake_ec2'
require 'fake_ec2/model'

module FakeEc2
  module Model
    class Reservation < Base
      field :reservation_id
      field :group_id
      field :instances_set
    end
  end
end

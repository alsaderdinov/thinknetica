# frozen_string_literal: true

class PassengerWagon < Wagon
  validate :space, :presence

  def initialize(space)
    super(:passenger, space)
  end
end

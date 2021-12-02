# frozen_string_literal: true

class CargoWagon < Wagon
  validate :space, :presence

  def initialize(space)
    super(:cargo, space)
  end
end

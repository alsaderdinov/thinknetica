require_relative 'wagon'

class CargoWagon < Wagon
  def initialize(space)
    super(:cargo, space)
  end
end

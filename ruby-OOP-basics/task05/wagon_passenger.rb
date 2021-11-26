require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize(space)
    super(:passenger, space)
  end
end

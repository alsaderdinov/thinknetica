# frozen_string_literal: true

class CargoTrain < Train
  attr_accessors_with_history :route

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, :cargo)
  end
end

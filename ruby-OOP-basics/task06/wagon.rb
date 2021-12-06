# frozen_string_literal: true

require_relative 'module_manufacturer'
require_relative 'module_validation'

class Wagon
  include Manufacturer
  include Validation

  attr_reader :type, :occupied_space

  validate :type, :presence
  validate :space, :presence

  def initialize(type, space)
    @type = type
    @space = space
    @occupied_space = 0
    validate!
  end

  def take_seat(value = 1)
    @occupied_space += value if @type.eql?(:passenger)
    raise 'Volume is over' if @occupied_space > @space
  end

  def take_volume(value = 1)
    @occupied_space += value if @type.eql?(:cargo)
    raise 'Volume is over' if @occupied_space > @space
  end

  def free_space
    @space - @occupied_space
  end
end

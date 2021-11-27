require_relative 'module_manufacturer'

class Wagon
  include Manufacturer
  attr_reader :type, :occupied_space

  def initialize(type, space)
    @type = type
    @space = space
    @occupied_space = 0
    validate!
  end

  def valid?
    validate!
    true
  rescue
    false
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

  protected

  def validate!
    raise 'Invalid wagon type' unless @type.eql?(:cargo) || @type.eql?(:passenger)
  end
end

# frozen_string_literal: true

require_relative 'module_manufacturer'
require_relative 'module_instance_counter'
require_relative 'module_validation'
require_relative 'module_accessors'

class Train
  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i.freeze

  include Manufacturer
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :number, :type, :wagons

  strong_attr_accessor :number, String
  strong_attr_accessor :speed, Integer

  validate :type, :presence
  validate :number, :format, NUMBER_FORMAT

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @route = nil
    @station_index = nil
    @@trains[number] = self
    validate!
    register_instance
  end

  def each_wagon(&block)
    @wagons.each { |wagon| block.call(wagon) }
  end

  def increase_speed
    increase_speed! unless max_speed?
  end

  def decrease_speed
    decrease_speed! unless train_stopped?
  end

  def stop
    @speed = 0 unless train_stopped?
  end

  def current_speed
    @speed
  end

  def current_wagons
    @wagons
  end

  def attach_wagon(wagon)
    @wagons << wagon if train_stopped? && type_match?(wagon)
  end

  def deattach_wagon
    @wagons.pop
  end

  def add_route(route)
    @route = route
    @station_index = 0
    current_station.add_train(self)
  end

  def current_station
    @route.show_route[@station_index]
  end

  def previous_station
    previous_station! unless first_station?
  end

  def next_station
    next_station! unless last_station?
  end

  def move_forward
    current_station.send_train(self)
    current_station.add_train(self)
    @station_index += 1
  end

  def move_backward
    current_station.send_train(self)
    current_station.add_train(self)
    @station_index -= 1
  end

  # These are validation and readability-enhancing methods.
  # The user does not need to interact with them directly.
  protected

  def max_speed?
    @speed == 200
  end

  def train_stopped?
    @speed.zero?
  end

  def type_match?(wagon)
    @type == wagon.type
  end

  def increase_speed!
    @speed += 20
  end

  def decrease_speed!
    @speed -= 20
  end

  def next_station!
    @route.show_route[@station_index + 1]
  end

  def previous_station!
    @route.show_route[@station_index - 1]
  end

  def first_station?
    current_station == @route.show_route.first
  end

  def last_station?
    current_station == @route.show_route.last
  end
end

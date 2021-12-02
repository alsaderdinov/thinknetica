# frozen_string_literal: true

require_relative 'module_instance_counter'
require_relative 'module_validation'
require_relative 'module_accessors'

class Station
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :name, :trains

  validate :name, :presence

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    validate!
    register_instance
  end

  def each_train(&block)
    @trains.each { |train| block.call(train) }
  end

  def add_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def show_trains
    @trains
  end

  def show_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def remove_train(train)
    @trains.delete(train)
  end
end

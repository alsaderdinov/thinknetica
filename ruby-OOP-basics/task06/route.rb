# frozen_string_literal: true

require_relative 'module_instance_counter'
require_relative 'module_validation'
require_relative 'station'

class Route
  include InstanceCounter
  include Validation

  validate :start, :type, Station
  validate :finish, :type, Station
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
    @points = []
    validate!
    register_instance
  end

  def add_point(point)
    @points << point
  end

  def remove_point(point)
    @points.delete(point)
  end

  def show_route
    [@start, @points, @finish].flatten
  end
end

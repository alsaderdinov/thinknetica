require_relative 'module_instance_counter'

class Route
  include InstanceCounter
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
    @points = []
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

require_relative 'module_instance_counter'

class Route
  include InstanceCounter
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

  def valid?
    validate!
    true
  rescue
    false
  end

  protected

  def validate!
    raise 'Stations name must be different' if @start.eql? @finish
  end
end

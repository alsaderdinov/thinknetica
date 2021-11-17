class Route
  attr_accessor :first, :points, :last, :arr

  def initialize(first, last)
    @first = first
    @last = last
    @points = []
  end

  def add(station)
    @points << station
  end

  def delete(station)
    @points.delete(station)
  end

  def show_stations
    [@first, @points, @last].flatten
  end
end

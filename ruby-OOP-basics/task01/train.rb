class Train
  attr_accessor :number, :type, :wagons, :speed, :route, :station_index

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @wagons = wagons
    @speed = 0
    @route = nil
    @station_index = nil
  end

  def increase_speed
    @speed > 200 ? 200 : @speed += 20
  end

  def decrease_speed
    @speed.zero? ? 0 : @speed -= 20
  end

  def stop
    @speed = 0
  end

  def attach_wagon
    @wagons += 1 if @speed.zero?
  end

  def deattach_wagon
    @wagons -= 1 if @speed.zero? && @wagons.positive?
  end

  def add_route(route)
    @route = route
    @station_index = 0
    current_station.accept(self)
  end

  def current_station
    @route.show_stations[@station_index]
  end

  def next_station
    @route.show_stations[@station_index + 1] unless last_station?
  end

  def previous_station
    @route.show_stations[@station_index - 1] unless first_station?
  end

  def move_forward
    current_station.send(self)
    current_station.accept(self)
    @station_index += 1
  end

  def move_backward
    current_station.send(self)
    current_station.accept(self)
    @station_index -= 1
  end

  def first_station?
    current_station == route.show_stations.first
  end

  def last_station?
    current_station == route.show_stations.last
  end
end

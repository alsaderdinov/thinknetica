class Train
  attr_reader :number, :type, :wagons

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @route = nil
    @station_index = nil
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
    @wagons << wagon if train_stopped?
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

  protected

  # These are methods for checking and improving understanding of the code.
  # The user does not need to interact with them directly

  def max_speed?
    @speed == 200
  end

  def train_stopped?
    @speed.zero?
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

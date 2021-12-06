# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'train_cargo'
require_relative 'train_passenger'
require_relative 'wagon'
require_relative 'wagon_cargo'
require_relative 'wagon_passenger'

class Main
  attr_reader :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  def context_menu
    loop do
      context
      puts 'Select option'
      select = gets.to_i

      case select
      when 1
        station_create
      when 2
        train_create
      when 3
        route_create
      when 4
        route_add_station
      when 5
        route_delete_station
      when 6
        train_set_route
      when 7
        train_attach_wagon
      when 8
        train_deattach_wagon
      when 9
        train_move_forward
      when 10
        train_move_backward
      when 11
        show_station_trains
      when 12
        show_train_wagons
      when 13
        wagon_take_space
      when 0
        break
      end
    end
  end

  private

  def station_create
    puts 'Enter station name'
    name = gets.chomp
    station = Station.new(name)
    @stations << station
    puts "Station => #{station.name} was created"
  rescue RuntimeError => e
    puts "Error: #{e}"
  end

  def train_create
    puts 'Enter train number'
    number = gets.chomp

    puts 'Enter train type'
    puts '0 => cargo : 1 => passenger'

    type = gets.to_i.zero? ? :cargo : :passenger
    train = Train.new(number, type)

    @trains << train
    puts "Train name: #{train.number} || Train type: #{train.type} was created"
  rescue RuntimeError => e
    puts "Error: #{e}"
    retry
  end

  def route_create
    if @stations.size < 2
      puts "Route can't be created"
    else
      @stations.each.with_index { |v, i| puts "#{i} => #{v.name}" }
      puts 'Select the start station'
      start_station = gets.to_i

      puts 'Select the finish station'
      finish_station = gets.to_i

      route = Route.new(@stations[start_station], @stations[finish_station])
      @routes << route

      puts "Route was created => \
       #{@stations[start_station].name} : #{@stations[finish_station].name}"
    end
  rescue RuntimeError => e
    puts "Error: #{e}"
  end

  def route_add_station
    if @routes.empty?
      puts 'Route is empty'
    else
      @routes.each.with_index \
       { |v, i| puts "#{i} => #{v.start.name} : #{v.finish.name}" }
      puts 'Select the route'
      route = gets.to_i

      @stations.each.with_index { |v, i| puts "#{i} => #{v.name}" }
      puts 'Select the station'
      station = gets.to_i

      @routes[route].add_point(@stations[station])
      puts "Station #{@stations[station].name} was added "
    end
  end

  def train_attach_wagon
    if @trains.empty?
      puts 'No have trains'
    else
      @trains.each.with_index { |v, i| puts "#{i} => #{v.number}" }
      puts 'Select the train'
      train = gets.to_i

      case @trains[train].type
      when :cargo
        puts 'Set the volume'
        volume = gets.to_i
        @trains[train].attach_wagon(CargoWagon.new(volume))
        puts 'cargo wagon was attached'
      when :passenger
        puts 'Set the places'
        places = gets.to_i
        @trains[train].attach_wagon(PassengerWagon.new(places))
        puts 'passenger wagon was attached'
      end
    end
  end

  def train_deattach_wagon
    if @trains.empty?
      puts 'No have trains'
    else
      @trains.each.with_index { |v, i| puts "#{i} => #{v.number}" }
      puts 'Select the train'
      train = gets.to_i

      @trains[train].deattach_wagon
      puts 'Wagon was deattached'
    end
  end

  def route_delete_station
    if @routes.empty?
      puts 'Stations is empty'
    else
      @routes.each.with_index \
       { |v, i| puts "#{i} => #{v.start.name} : #{v.finish.name}" }
      puts 'Select the route'
      route = gets.to_i

      @stations.each.with_index { |v, i| puts "#{i} => #{v.name}" }
      puts 'Choose station'
      station = gets.to_i

      @routes[route].remove_point(@stations[station])
      puts "Station: #{@stations[station].name} was deleted"
    end
  end

  def train_set_route
    if @routes.empty?
      puts "Route can't be setted"
    else
      @trains.each.with_index { |v, i| puts "#{i} => #{v.number}" }
      puts 'Select the train'
      train = gets.to_i

      @routes.each.with_index \
       { |v, i| puts "#{i} => #{v.start.name} : #{v.finish.name}" }
      puts 'Select the route'
      route = gets.to_i

      @trains[train].add_route(@routes[route])
      puts " Route: #{@routes[route].start} => #{@routes[route].finish} was added"
    end
  end

  def train_move_forward
    if @trains.empty?
      puts 'No have trains'
    else
      @trains.each.with_index { |v, i| puts "#{i} => #{v.number}" }
      puts 'Select the train'
      train = gets.to_i
      @trains[train].move_forward
    end
  end

  def train_move_backward
    if @trains.empty?
      putus 'No have trains'
    else
      @trains.each.with_index { |v, i| puts "#{i} => #{v.number}" }
      puts 'Select the train'
      train = gets.to_i
      @trains[train].move_backward
    end
  end

  def wagon_take_space
    puts 'Select the train'
    @trains.each.with_index { |v, i| puts "#{i} => #{v.number}" }
    train = gets.to_i
    puts 'Select the wagon'
    wagon = gets.to_i
    if @trains[train].wagons[wagon].type == :cargo
      puts 'Volume'
      @trains[train].wagons[wagon].take_volume(gets.to_i)
      puts 'Wagon was loaded'
      puts "Free volume: #{@trains[train].wagons[wagon].free_space}"
    else
      puts 'Seats'
      @trains[train].wagons[wagon].take_seat(gets.to_i)
      puts 'Seat is taken'
      puts "Free seats: #{@trains[train].wagons[wagon].free_space}"
    end
  end

  def show_station_trains
    @stations.each do |station|
      puts "#Station: #{station.name}"
      station.trains.each do |train|
        puts "Train number: #{train.number} || Train type: #{train.type} || Wagons #{train.wagons.size} "
      end
    end
  end

  def show_train_wagons
    puts 'Select the train'
    @trains.each.with_index { |v, i| puts "#{i} => #{v.number}" }
    train = gets.to_i
    train = @trains[train]
    train.each_wagon do |wagon|
      if wagon.type == :passenger
        puts "Wagon: #{Random.rand(22)}
        Type: #{wagon.type} || Free seats: #{wagon.free_space} || Occupied seats: #{wagon.occupied_space} "
      else
        puts "Wagon: #{Random.rand(22)}
        Type: #{wagon.type} || Free volume: #{wagon.free_space} || Occupied volume: #{wagon.occupied_space}"
      end
    end
  end

  def context
    puts '1 Create station'
    puts '2 Create train'
    puts '3 Create route'
    puts '4 Add station in route'
    puts '5 Delete station from route'
    puts '6 Set route to train'
    puts '7 Attach wagon to train'
    puts '8 Deattach wagon from train'
    puts '9 Train move forward'
    puts '10 Train move backward'
    puts '11 Show station trains'
    puts '12 Show wagons train'
    puts '13 Wagon take a space'
    puts '0 Exit'
  end
end

Main.new.context_menu

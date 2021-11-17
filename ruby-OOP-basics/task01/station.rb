class Station
  attr_accessor :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def accept(train)
    trains << train
  end

  def send(train)
    trains.delete(train)
  end

  def show_by_type(type)
    @trains.select { |train| train.type == type }
  end
end

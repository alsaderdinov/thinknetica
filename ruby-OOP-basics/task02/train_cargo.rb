class CargoTrain < Train
  def initialize(number)
    super(number, :cargo)
  end

  def attach_wagon(wagon)
    super if @type == wagon.type
  end
end

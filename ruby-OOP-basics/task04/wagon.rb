require_relative 'module_manufacturer'

class Wagon
  include Manufacturer
  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  protected

  def validate!
    raise 'Invalid wagon type' unless @type.eql?(:cargo) || @typpe.eql?(:passenger)
  end
end

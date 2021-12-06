# frozen_string_literal: true

module Accessors
  def attr_accessors_with_history(*names)
    names.each { |name| define_accessor_with_history(name) }
  end

  def strong_attr_accessor(name, class_of)
    name_sym = "@#{name}".to_sym

    define_method(name) { instance_variable_get(name_sym) }
    define_method("#{name}=".to_sym) do |value|
      raise 'Invalid type' unless value.is_a?(class_of)

      instance_variable_set(name_sym, value)
    end
  end

  protected

  def define_accessor_with_history(name)
    name_sym = "@#{name}".to_sym
    history = "@#{name}_history".to_sym

    define_method(name) { instance_variable_get(name_sym) }
    define_method("#{name}=".to_sym) do |value|
      if instance_variable_get(name_sym).nil?
        instance_variable_set(history, [])
      else
        instance_variable_get(history) << instance_variable_get(name_sym)
      end
      instance_variable_set(name_sym, value)
    end
    define_method("#{name}_history".to_sym) { instance_variable_get(history) }
  end
end

# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(name, type, args = nil)
      validations << { name: name, type: type, args: args }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |valid|
        argument_value = instance_variable_get("@#{valid[:name]}")
        method_name = "validate_#{valid[:type]}"
        send(method_name, argument_value, valid[:args])
      end
    end

    def vaid?
      validate!
      true
    rescue StandardError
      false
    end

    protected

    def validation_presence(value, _args)
      raise "Value can't be empty" if value.nil? || value.to_s.empty?
    end

    def validation_format(value, format)
      raise 'Invalid fomrat value' if value !~ format
    end

    def validation_type(value, class_of)
      raise 'Invalid type value' unless value.is_a?(class_of)
    end
  end
end

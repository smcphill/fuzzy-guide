# frozen_string_literal: true

module Ferociacalc
  class InputDefinition
    attr_reader :name, :description
    def initialize(name, description, to_type, validator, transformer)
      @name = name
      @description = description
      @to_type = to_type
      @validator = validator
      @transformer = transformer
    end

    def transform_type(value)
      @to_type.call(value)
    end

    def validate_value(value)
      @validator.call(value)
    end

    def transform_value(value)
      @transformer.call(value)
    end
  end
end

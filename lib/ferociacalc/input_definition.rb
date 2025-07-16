# frozen_string_literal: true

module Ferociacalc
  class InputDefinition
    def initialize(name, description, to_type, validator, transformer)
      @name = name
      @description = description
      @to_type = to_type
      @validator = validator
      @transformer = transformer
    end
  end
end

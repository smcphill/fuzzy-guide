# frozen_string_literal: true


module Ferociacalc
  # parses user args into defined calculator inputs
  class Parser
    def initialize(calculator, calculator_args)
      @calculator_inputs = calculator.class.inputs
      @calculator_args = calculator_args
    end

    # Returns a hash of calculator inputs, keyed by input name
    def parse(args)
      collected_inputs = {}
      @calculator_args.each_with_index do |arg, index|
        transformed_value = self.class.extract_input(@calculator_inputs[arg], args[index])
        collected_inputs[arg] = transformed_value
      end
      collected_inputs
    end

    private_methods

    # applies the input definition logic against the provide value
    def self.extract_input(input_definition, value)
      typed_value = input_definition[:option_type].call(value)
      input_definition[:validator].call(typed_value)

      input_definition[:transformer].call(typed_value)
    end

  end
end

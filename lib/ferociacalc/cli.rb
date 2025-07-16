# frozen_string_literal: true

require 'ferociacalc/term_deposit_calculator'

module Ferociacalc
  class CLI
    def initialize(argv = [])
      args = argv.dup
      # emit help if no args given
      args << '-h' if args.empty?

      @defined_inputs = {}
      @calculator = Ferociacalc::TermDepositCalculator.new

      parse_options(args)
    end

    def call
      result = calculate
      present(result)
    end

    private_methods

    def calculate
      @calculator.call(**@defined_inputs)
    end

    # Inline CLI Presenter: dumps the formatted result to stdout
    def present(result)
      formatted_result = <<~HEREDOC
        Final balance: $#{'%.2f' % result.total.round(0)}
        Total interest earned:  $#{'%.2f' % result.interest_accrued.round(0)}
      HEREDOC

      puts formatted_result
    end

    def self.print_help(expected_args, input_definitions)
      input_details = expected_args.map {|arg| "#{arg}:    \t#{input_definitions[arg][:description]}"}

      puts <<~HEREDOC
        #{banner(expected_args)}

        #{input_details.join("\n")}

      HEREDOC
    end

    def self.banner(expected_args)
      "Usage: ferociacalc <#{expected_args.join('> <')}>"
    end

    # Inline parser: populates @defined_inputs as required by @calculator
    def parse_options(args)
      calculator_args = %i[initial_deposit interest_rate deposit_term interest_frequency]
      calculator_inputs = @calculator.class.inputs
      if args.empty? || args.size != calculator_args.size
        self.class.print_help(calculator_args, calculator_inputs)
        raise 'Exiting'
      end

      calculator_args.each_with_index do |arg, index|
        transformed_value = self.class.extract_input(calculator_inputs[arg], args[index])

        @defined_inputs[arg] = transformed_value
      end

      missing_options = calculator_args - @defined_inputs.keys

      return if missing_options.empty?

      # otherwise, print help and raise
      self.class.print_help(calculator_args, calculator_inputs)
      raise "Missing required options: #{missing_options.map(&:to_s).join(', ')}"
    end

    # applies the input definition logic against the provide value
    def self.extract_input(input_definition, value)
      typed_value = input_definition[:option_type].call(value)

      input_definition[:validator].call(typed_value)

      input_definition[:transformer].call(typed_value)
    end
  end
end

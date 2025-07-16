# frozen_string_literal: true

require 'ferociacalc/term_deposit_calculator'
require 'ferociacalc/parser'

module Ferociacalc
  class CLI
    def initialize(argv = [])
      args = argv.dup

      @calculator = Ferociacalc::TermDepositCalculator.new
      @defined_inputs = parse_options(args)
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

    def self.print_help_and_exit(expected_args, input_definitions, exit_message)
      print_help(expected_args, input_definitions)
      raise exit_message
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
        self.class.print_help_and_exit(calculator_args, calculator_inputs, 'Exiting')
      end

      parser = Ferociacalc::Parser.new(@calculator, calculator_args)
      parser.parse(args)
    rescue StandardError => e
      self.class.print_help_and_exit(calculator_args, calculator_inputs, e.message)
    end
  end
end

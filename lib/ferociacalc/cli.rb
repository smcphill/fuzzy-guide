# frozen_string_literal: true

require 'optparse'
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

    # Inline parser: populates @defined_inputs as required by @calculator
    def parse_options(args)
      parser = OptionParser.new do |p|
        p.banner = 'Usage: ferociacalc [options]'
        options_for_calculator_inputs(p)
      end
      parser.parse!(args, into: @defined_inputs)
      required_options = @calculator.class.inputs.keys
      missing_options = required_options - @defined_inputs.keys

      return if missing_options.empty?

      # otherwise, print help and raise
      puts parser
      raise "Missing required options: #{missing_options.map(&:to_s).join(', ')}"
    end

    # Setup parser to source named inputs from the calculator and retrieve them from user input
    def options_for_calculator_inputs(parser)
      @calculator.class.inputs.each do |input, details|
        long_option = "--#{input} #{details[:long_opt]}"
        parser.on(details[:short_opt], long_option, details[:option_type], details[:description]) do |option|
          # this enforces any requirements the calculator imposes on the given option (i.e. non-negative balances!)
          details[:requires].call(option)
          @defined_inputs[input] = details[:marshal].call(option)
        end
      end
    end
  end
end

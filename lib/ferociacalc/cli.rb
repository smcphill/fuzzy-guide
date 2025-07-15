# frozen_string_literal: true

require 'ferociacalc/term_deposit_calculator'

module Ferociacalc
  class CLI
    def initialize(argv = [])
      @args = argv.dup
      @calculator = Ferociacalc::TermDepositCalculator.new
    end

    def parse_options
      fail NotImplementedError
    end

    def calculate
      # TODO: source required inputs from @calculator.class.inputs.keys
      @calculator.call(
        initial_deposit: @args[0].to_f,
        interest_rate: @args[1].to_f,
        deposit_term: @args[2].to_i,
        interest_frequency: @args[3].to_i
      )
    end
  end
end

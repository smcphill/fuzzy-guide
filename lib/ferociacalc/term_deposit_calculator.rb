# frozen_string_literal: true

require 'ferociacalc/result'

# A functional term deposit calculator
module Ferociacalc
  class TermDepositCalculator
    # perform the calculation given the required inputs
    # returns a multiline string:
    #     "Final balance: $XX.00\n
    #      Total interest earned:  $XX.00\n"
    def call(initial_deposit:, interest_rate:, deposit_term:, interest_frequency:)
      calculate_compounding_term_deposit(
        principal: initial_deposit,
        rate: interest_rate,
        term: deposit_term,
        compounding_frequency: interest_frequency
      )
    end

    # TODO: way too much responsibility for anonymous hashes (domain objects lurking)
    # (also tightly coupled to 'optparse': not appropriate responsibility for the Calculator)
    def self.inputs # rubocop:disable Metrics/MethodLength
      # defines the inputs this calculator requires. the toplevel keys here are used by `#call`
      {
        initial_deposit: {
          option_type: ->(val) { Float(val) },
          description: 'Required Initial deposit amount in dollars ($1_000.00 - $1_500_000.00)',
          validator: lambda do |val|
            raise "must provide a valid initial deposit amount (was #{val})" unless (val <= 1_500_500) && (val >= 1_000)
          end,
          transformer: ->(val) { val }
        },
        interest_rate: {
          option_type: ->(val) { Float(val) },
          description: 'Required Interest rate % p.a (0-15; e.g. 3% is 3, not 0.03)',
          validator: lambda do |val|
            raise "must provide a valid interest rate number (was #{val})" unless (val >= 0) && (val <= 15)
          end,
          transformer: ->(val) { (val / 100).to_f }
        },
        deposit_term: {
          option_type: ->(val) { Integer(val) },
          description: 'Required Deposit term in months (3-60; e.g. 12)',
          validator: lambda do |val|
            raise "must provide a valid number of months (was #{val})" unless (val >= 3) && (val <= 60)
          end,
          transformer: ->(val) { (val / 12.0) }
        },
        interest_frequency: {
          option_type: ->(val) { String(val) },
          description: "Required Interest payment period (i.e. #{interest_periods.keys.join(', ')})",
          validator: lambda do |val|
            raise "must provide a valid interest period (was #{val})" unless interest_periods.keys.include?(val)
          end,
          transformer: ->(val) { interest_periods[val] }
        }
      }
    end

    private_methods

    # we need to compound a _fixed term_ deposit: A = P (1 + r/n)^(nt)
    # where
    # A = Calculation result
    # P = (principal) starting deposit (or principal)
    # r = (rate) interest rate per annum as a decimal (for example, 2% becomes 0.02)
    # n = (compounding_frequency) the compounding frequency
    # t = (term) the deposit term in years
    # (source: https://www.ujjivansfb.in/banking-blogs/deposits/how-compound-interest-in-fixed-deposits-work)
    # returns a Ferociacalc::Result
    def calculate_compounding_term_deposit(principal:, rate:, term:, compounding_frequency:)
      maturity_calculation = -> { principal * (1 + (rate * term)) }
      periodic_calculation = -> { principal * ((1 + (rate / compounding_frequency))**(compounding_frequency * term)) }

      calculation = compounding_frequency.zero? ? maturity_calculation.call :  periodic_calculation.call
      Ferociacalc::Result.new(calculation.to_f, (calculation - principal).to_f)
    end

    def self.interest_periods
      {
        'monthly' => 12,
        'quarterly' => 4,
        'annually' => 1,
        'maturity' => 0
      }
    end
  end
end

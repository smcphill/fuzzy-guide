# A functional term deposit calculator
module Ferociacalc
  class TermDepositCalculator
    # perform the calculation given the required inputs
    # returns a multiline string:
    #     "Final balance: $XX.00\n
    #      Total interest earned:  $XX.00\n"
    def call(initial_deposit:, interest_rate:, deposit_term:, interest_frequency:)
      # ensure inputs are the right shape (decimal rate, term in years)
      calculate_compounding_term_deposit(
        principal: initial_deposit,
        rate: (interest_rate / 100).to_f,
        term: (deposit_term / 12.0).to_f,
        compounding_frequency: interest_frequency
      )
    end

    def self.inputs # rubocop:disable Metrics/MethodLength
      interest_periods = %w[monthly quarterly annually maturity]
      # defines the inputs this calculator requires. the toplevel keys here are used by `#call`
      {
        initial_deposit: {
          short_opt: '-d DOLLARS',
          long_opt: 'DOLLARS',
          option_type: Float,
          description: 'Required Initial deposit amount in dollars ($1_000.00 - $1_500_000.00)',
          requires: lambda do |val|
            raise "must provide a valid initial deposit amount (was #{val})" unless (val <= 1_500_500) && (val >= 1_000)
          end
        },
        interest_rate: {
          short_opt: '-i PERCENT',
          long_opt: 'PERCENT',
          option_type: Float,
          description: 'Required Interest rate % p.a (0-15; e.g. 3% is 3, not 0.03)',
          requires: lambda do |val|
            raise "must provide a valid interest rate number (was #{val})" unless (val >= 0) && (val <= 15)
          end
        },
        deposit_term: {
          short_opt: '-t MONTHS',
          long_opt: 'MONTHS',
          option_type: Integer,
          description: 'Required Deposit term in months (3-60; e.g. 12)',
          requires: lambda do |val|
            raise "must provide a valid number of months (was #{val})" unless (val >= 3) && (val <= 60)
          end
        },
        interest_period: {
          short_opt: "-p PERIOD < #{interest_periods.join(' | ')} >",
          long_opt: "PERIOD < #{interest_periods.join(' | ')} >",
          option_type: String,
          description: "Required Interest payment period (e.g. #{interest_periods[0]})",
          requires: lambda do |val|
            raise "must provide a valid interest period (was #{val})" unless interest_periods.include?(val)
          end
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
    #
    # note our percentage is not expected as a decimal (e.g. 2% is 2.0, not 0.02)
    # frequency:
    #  -  0: at maturity
    #  -  1: annually
    #  -  4: quarterly
    #  - 12: monthly
    def calculate_compounding_term_deposit(principal:, rate:, term:, compounding_frequency:)
      maturity_calculation = -> { principal * (1 + (rate * term)) }
      periodic_calculation = -> { principal * ((1 + (rate / compounding_frequency))**(compounding_frequency * term)) }

      calculation = compounding_frequency.zero? ? maturity_calculation.call :  periodic_calculation.call

      <<~HEREDOC
        Final balance: $#{'%.2f' % calculation.round(0)}
        Total interest earned:  $#{'%.2f' % (calculation - principal).round(0)}
      HEREDOC
    end
  end
end

# frozen_string_literal: true

require 'term_deposit_calculator'

# Initial MVP runner
class CLI
  def call(args)
    parsed_args = self.class.calculator_inputs(args)
    result = TermDepositCalculator.new.call(**parsed_args)

    self.class.present_calculation(result[0], result[1])
  end

  # the calculator expects mixed time periods: term in months, rate and frequency per year
  def self.calculator_inputs(args)
    {
      initial_deposit: parse_initial_deposit(args[0]),
      interest_rate: parse_interest_rate(args[1]),
      deposit_term: parse_deposit_term(args[2]),
      interest_frequency: parse_interest_frequency(args[3])
    }
  end

  def self.present_calculation(total, interest)
    <<-HEREDOC
    Final balance: $#{format('%.2f', total.round(0))}
    Total interest earned:  $#{format('%.2f', interest.round(0))}
    HEREDOC
  end

  # returns a float (dollars)
  def self.parse_initial_deposit(initial_deposit)
    initial_deposit.to_f
  end

  # returns a float (interest p.a.)
  def self.parse_interest_rate(interest_rate)
    (interest_rate.to_f / 100)
  end

  # returns a float (years)
  def self.parse_deposit_term(deposit_term)
    (deposit_term.to_f / 12)
  end

  # returns months per frequency period
  # hardcoded to monthly for now
  def self.parse_interest_frequency(interest_frequency)
    frequency = frequency_periods[interest_frequency.to_sym]
    raise ArgumentError, 'Unknown compounding frequency' if frequency.nil?

    frequency.to_i
  end

  def self.frequency_periods
    {
      monthly: 12,
      quarterly: 4,
      annually: 1,
      maturity: 0
    }
  end
end

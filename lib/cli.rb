require 'term_deposit_calculator'

# Initial MVP runner
class CLI
  def call(args)
    # the calculator expects mixed time periods: term in months, rate and frequency per year
    TermDepositCalculator.new.call(
      initial_deposit: self.class.parse_initial_deposit(args[0]),
      interest_rate: self.class.parse_interest_rate(args[1]),
      deposit_term: self.class.parse_deposit_term(args[2]),
      interest_frequency: self.class.parse_interest_frequency(args[3])
    )
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
    raise 'Unknown interest frequency' if frequency.nil?

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

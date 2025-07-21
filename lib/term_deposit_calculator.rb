# frozen_string_literal: true

# A functional term deposit calculator
class TermDepositCalculator
  # perform the calculation given the required inputs
  # returns a multiline string:
  #     "Final balance: $XX.00\n
  #      Total interest earned:  $XX.00\n"
  def call(initial_deposit:, interest_rate:, deposit_term:, interest_frequency:)
    # ensure inputs are the right shape (decimal rate, term in years)
    calculate_compounding_term_deposit(
      principal: self.class.validate_initial_deposit(initial_deposit),
      rate: self.class.validate_interest_rate(interest_rate),
      term: self.class.validate_deposit_term(deposit_term),
      compounding_frequency: self.class.validate_interest_frequency(interest_frequency)
    )
  end

  def self.validate_initial_deposit(initial_deposit)
    raise 'Initial deposit must be within $1_000-$1_500_000' if initial_deposit < 1_000 || initial_deposit > 1_500_000

    initial_deposit
  end

  def self.validate_interest_rate(interest_rate)
    raise 'Interest rate must be within 0%-15%' if interest_rate.negative? || interest_rate > 0.15

    interest_rate
  end

  def self.validate_deposit_term(deposit_term)
    raise 'Deposit term must be within 1-5 years' if deposit_term < 1 || deposit_term > 5

    deposit_term
  end

  def self.validate_interest_frequency(interest_frequency)
    valid_frequencies = {
      monthly: 12,
      quarterly: 4,
      annually: 1,
      maturity: 0
    }
    invalid_message = "Interest frequency must be one of #{valid_frequencies.keys.join(', ')}"

    raise invalid_message unless valid_frequencies.values.include?(interest_frequency)

    interest_frequency
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
  def calculate_compounding_term_deposit(principal:, rate:, term:, compounding_frequency:)
    maturity_calculation = -> { principal.to_f * (1 + (rate * term)) }
    periodic_calculation = -> { principal.to_f * ((1 + (rate / compounding_frequency))**(compounding_frequency * term)) }

    calculation = compounding_frequency.zero? ? without_compounding.call : periodic_calculation.call

    <<-HEREDOC
    Final balance: $#{format('%.2f', calculation.round(0))}
    Total interest earned:  $#{format('%.2f', (calculation - principal).round(0))}
    HEREDOC
  end
end

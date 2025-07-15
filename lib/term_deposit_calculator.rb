# A functional term deposit calculator
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
    maturity_calculation = -> { principal.to_f * (1 + (rate * term)) }
    periodic_calculation = -> { principal.to_f * ((1 + (rate / compounding_frequency))**(compounding_frequency * term)) }

    calculation = compounding_frequency.zero? ? maturity_calculation.call :  periodic_calculation.call

    <<-HEREDOC
    Final balance: $#{'%.2f' % calculation.round(0)}
    Total interest earned:  $#{'%.2f' % (calculation - principal).round(0)}
    HEREDOC
  end
end

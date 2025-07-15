require 'term_deposit_calculator'

# Initial MVP runner
class MVP
  def call
    TermDepositCalculator.new.call(
      initial_deposit: 1000,
      interest_rate: 3.5,
      deposit_term: 12,
      interest_frequency: 1
    )
  end
end

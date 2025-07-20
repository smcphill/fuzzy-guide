require 'term_deposit_calculator'

# Initial MVP runner
class CLI
  def call(args)
    # the calculator expects mixed time periods: term in months, rate and frequency per year
    TermDepositCalculator.new.call(
      initial_deposit: args[0].to_f,
      interest_rate: args[1].to_f,
      deposit_term: args[2].to_i,
      interest_frequency: args[3].to_i
    )
  end
end

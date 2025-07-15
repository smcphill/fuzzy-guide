# A functional term deposit calculator
class TermDepositCalculator
  # perform the calculation given the required inputs
  # returns a multiline string:
  #     "Final balance: $XX.00\n
  #      Total interest earned:  $XX.00\n"
  def call(initial_deposit:, interest_rate:, deposit_term:, interest_frequency:)
    raise NotImplementedError
  end
end

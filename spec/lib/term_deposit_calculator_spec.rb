require 'term_deposit_calculator'

describe TermDepositCalculator do
  let(:args) do
    {
      initial_deposit: 1000,
      interest_rate: 3.5,
      deposit_term: 12,
      interest_frequency: 1
    }
  end

  it 'is here' do
    expect { described_class.new.call(**args)}.to raise_error(NotImplementedError)
  end
end

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

  context 'with annual frequency' do
    it 'works' do
      expected_output = "    Final balance: $1035.00\n    Total interest earned:  $35.00\n"
      expect(described_class.new.call(**args)).to eq(expected_output)
    end
  end

  context 'with quarterly frequency' do
    let(:args) do
      {
        initial_deposit: 1000,
        interest_rate: 5.0,
        deposit_term: 12,
        interest_frequency: 4
      }
    end

    it 'works' do
      expected_output = "    Final balance: $1051.00\n    Total interest earned:  $51.00\n"
      expect(described_class.new.call(**args)).to eq(expected_output)
    end
  end

  context 'with monthly frequency' do
    let(:args) do
      {
        initial_deposit: 1000.0,
        interest_rate: 3.50,
        deposit_term: 12,
        interest_frequency: 12
      }
    end

    it 'works' do
      expected_output = "    Final balance: $1036.00\n    Total interest earned:  $36.00\n"
      expect(described_class.new.call(**args)).to eq(expected_output)
    end
  end

  context 'with frequency at maturity' do
    let(:args) do
      {
        initial_deposit: 1000,
        interest_rate: 5.0,
        deposit_term: 12,
        interest_frequency: 0
      }
    end

    it 'works' do
      expected_output = "    Final balance: $1050.00\n    Total interest earned:  $50.00\n"
      expect(described_class.new.call(**args)).to eq(expected_output)
    end
  end
end

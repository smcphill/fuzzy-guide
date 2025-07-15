# frozen_string_literal: true

require 'ferociacalc/term_deposit_calculator'

describe Ferociacalc::TermDepositCalculator do
  describe '#call' do
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
        expected_output = "Final balance: $1035.00\nTotal interest earned:  $35.00\n"
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
        expected_output = "Final balance: $1051.00\nTotal interest earned:  $51.00\n"
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
        expected_output = "Final balance: $1036.00\nTotal interest earned:  $36.00\n"
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
        expected_output = "Final balance: $1050.00\nTotal interest earned:  $50.00\n"
        expect(described_class.new.call(**args)).to eq(expected_output)
      end
    end
  end

  describe '.inputs' do
    it 'has the 4 input args required for the calculation' do
      expect(described_class.inputs.size).to eq(4)
    end

    it 'has the expected input keys' do
      expected_keys = %i[initial_deposit interest_rate deposit_term interest_period]
      expect(described_class.inputs.keys).to match_array(expected_keys)
    end

    describe 'initial_deposit' do
      let(:input) { described_class.inputs[:initial_deposit] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to eq('-d DOLLARS')
      end

      it 'is a float' do
        expect(input[:option_type]).to eq(Float)
      end

      it 'requires positive values gte 1000' do
        expect { input[:requires].call(1000) }.to_not raise_error

      end

      it 'raises on positive values lt 1000' do
        expect { input[:requires].call(10) }.to raise_error(/must provide a valid initial deposit amount/)
      end

      it 'raises on negative values' do
        expect { input[:requires].call(-2) }.to raise_error(/must provide a valid initial deposit amount/)
      end
    end

    describe 'interest_rate' do
      let(:input) { described_class.inputs[:interest_rate] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to eq('-i PERCENT')
      end

      it 'is a float' do
        expect(input[:option_type]).to eq(Float)
      end

      it 'requires positive values' do
        expect { input[:requires].call(2) }.to_not raise_error

      end

      it 'raises on negative values' do
        expect { input[:requires].call(-2) }.to raise_error(/must provide a valid interest rate number/)
      end
    end

    describe 'deposit_term' do
      let(:input) { described_class.inputs[:deposit_term] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to eq('-t MONTHS')
      end

      it 'is an integer' do
        expect(input[:option_type]).to eq(Integer)
      end

      it 'requires a valid value' do
        expect { input[:requires].call(3) }.to_not raise_error

      end

      it 'raises on negative values' do
        expect { input[:requires].call(-2) }.to raise_error(/must provide a valid number of months/)
      end
    end

    describe 'interest_period' do
      let(:input) { described_class.inputs[:interest_period] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to match(/^-p/)
      end

      it 'is a String' do
        expect(input[:option_type]).to eq(String)
      end

      it 'requires a valid interest period' do
        expect { input[:requires].call('monthly') }.to_not raise_error

      end

      it 'raises on an invalid interest period' do
        expect { input[:requires].call('daily') }.to raise_error(/must provide a valid interest period/)
      end
    end
  end
end

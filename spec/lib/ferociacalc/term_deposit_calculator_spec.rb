# frozen_string_literal: true

require 'ferociacalc/term_deposit_calculator'
require 'ferociacalc/result'

describe Ferociacalc::TermDepositCalculator do
  describe '#call' do
    let(:args) do
      {
        initial_deposit: 1000,
        interest_rate: 0.035,
        deposit_term: 1,
        interest_frequency: 1
      }
    end

    context 'with annual frequency' do
      it 'works' do
        result = described_class.new.call(**args)

        expect(result.total).to be_within(0.5).of(1035.0)
        expect(result.interest_accrued).to be_within(0.5).of(35.0)
      end
    end

    context 'with quarterly frequency' do
      let(:args) do
        {
          initial_deposit: 1000,
          interest_rate: 0.05,
          deposit_term: 1,
          interest_frequency: 4
        }
      end

      it 'works' do
        result = described_class.new.call(**args)

        expect(result.total).to be_within(0.5).of(1051.0)
        expect(result.interest_accrued).to be_within(0.5).of(51.0)
      end
    end

    context 'with monthly frequency' do
      let(:args) do
        {
          initial_deposit: 1000.0,
          interest_rate: 0.035,
          deposit_term: 1,
          interest_frequency: 12
        }
      end

      it 'works' do
        result = described_class.new.call(**args)

        expect(result.total).to be_within(0.5).of(1036.0)
        expect(result.interest_accrued).to be_within(0.5).of(36.0)
      end
    end

    context 'with frequency at maturity' do
      let(:args) do
        {
          initial_deposit: 1000,
          interest_rate: 0.05,
          deposit_term: 1,
          interest_frequency: 0
        }
      end

      it 'works' do
        result = described_class.new.call(**args)

        expect(result.total).to be_within(0.5).of(1050.0)
        expect(result.interest_accrued).to be_within(0.5).of(50.0)
      end
    end
  end

  describe '.inputs' do
    it 'has the 4 input args required for the calculation' do
      expect(described_class.inputs.size).to eq(4)
    end

    it 'has the expected input keys' do
      expected_keys = %i[initial_deposit interest_rate deposit_term interest_frequency]
      expect(described_class.inputs.keys).to match_array(expected_keys)
    end

    describe 'initial_deposit' do
      let(:input) { described_class.inputs[:initial_deposit] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to eq('-d DOLLARS')
      end

      it 'is a float' do
        expect(input[:option_type].call(5).class).to eq(Float)
      end

      it 'requires positive values gte 1_000' do
        expect { input[:requires].call(1_000) }.to_not raise_error

      end

      it 'raises on values lt 1_000' do
        expect { input[:requires].call(10) }.to raise_error(/must provide a valid initial deposit amount/)
      end

      it 'raises on values gt 1_500_000' do
        expect { input[:requires].call(2_000_000) }.to raise_error(/must provide a valid initial deposit amount/)
      end

      it 'has a noop marshal' do
        expect(input[:marshal].call(1_000)).to eq(1_000)
      end
    end

    describe 'interest_rate' do
      let(:input) { described_class.inputs[:interest_rate] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to eq('-i PERCENT')
      end

      it 'is a float' do
        expect(input[:option_type].call(10).class).to eq(Float)
      end

      it 'requires positive values' do
        expect { input[:requires].call(2) }.to_not raise_error

      end

      it 'raises on negative values' do
        expect { input[:requires].call(-2) }.to raise_error(/must provide a valid interest rate number/)
      end

      it 'is marshalled into a decimal' do
        expect(input[:marshal].call(3.5)).to eq(0.035)
      end
    end

    describe 'deposit_term' do
      let(:input) { described_class.inputs[:deposit_term] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to eq('-t MONTHS')
      end

      it 'is an integer' do
        expect(input[:option_type].call(10.0).class).to eq(Integer)
      end

      it 'requires a valid value' do
        expect { input[:requires].call(3) }.to_not raise_error

      end

      it 'raises on negative values' do
        expect { input[:requires].call(-2) }.to raise_error(/must provide a valid number of months/)
      end

      it 'is marshalled from months into years' do
        expect(input[:marshal].call(18)).to eq(1.5)
      end
    end

    describe 'interest_period' do
      let(:input) { described_class.inputs[:interest_frequency] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to match(/^-p/)
      end

      it 'is a String' do
        expect(input[:option_type].call(123).class).to eq(String)
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

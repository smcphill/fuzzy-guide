# frozen_string_literal: true

require 'term_deposit_calculator'

describe TermDepositCalculator do
  describe '#call' do
    let(:args) do
      {
        initial_deposit: 1000,
        interest_rate: 0.035,
        deposit_term: 1.0,
        interest_frequency: 1
      }
    end

    context 'with annual frequency' do
      it 'calculates the expected total' do
        expect(described_class.new.call(**args)[0]).to be_within(0.5).of(1035.00)
      end

      it 'calculates the expected interest' do
        expect(described_class.new.call(**args)[1]).to be_within(0.5).of(35.00)
      end
    end

    context 'with quarterly frequency' do
      let(:args) do
        {
          initial_deposit: 1000,
          interest_rate: 0.035,
          deposit_term: 1.0,
          interest_frequency: 4
        }
      end

      it 'calculates the expected total' do
        expect(described_class.new.call(**args)[0]).to be_within(0.5).of(1035.00)
      end

      it 'calculates the expected interest' do
        expect(described_class.new.call(**args)[1]).to be_within(0.5).of(35.00)
      end
    end

    context 'with monthly frequency' do
      let(:args) do
        {
          initial_deposit: 1000.0,
          interest_rate: 0.035,
          deposit_term: 1.0,
          interest_frequency: 12
        }
      end

      it 'calculates the expected total' do
        expect(described_class.new.call(**args)[0]).to be_within(0.5).of(1036.00)
      end

      it 'calculates the expected interest' do
        expect(described_class.new.call(**args)[1]).to be_within(0.5).of(36.00)
      end
    end

    context 'with frequency at maturity' do
      let(:args) do
        {
          initial_deposit: 1000.0,
          interest_rate: 0.05,
          deposit_term: 1.0,
          interest_frequency: 0
        }
      end

      it 'calculates the expected total' do
        expect(described_class.new.call(**args)[0]).to be_within(0.5).of(1050.00)
      end

      it 'calculates the expected interest' do
        expect(described_class.new.call(**args)[1]).to be_within(0.5).of(50.00)
      end
    end
  end

  describe '.validate_initial_deposit' do
    it 'returns the value when valid' do
      expect(described_class.validate_initial_deposit(1000.0)).to eq(1000.0)
    end

    it 'raises when invalid' do
      error_message = 'Initial deposit must be within $1_000-$1_500_000'
      expect do
        described_class.validate_initial_deposit(10.0)
      end.to raise_error(InvalidInputError).with_message(error_message)
    end
  end

  describe '.validate_interest_rate' do
    it 'returns the value when valid' do
      expect(described_class.validate_interest_rate(0.035)).to eq(0.035)
    end

    it 'raises when invalid' do
      error_message = 'Interest rate must be within 0%-15%'
      expect do
        described_class.validate_interest_rate(0.5)
      end.to raise_error(InvalidInputError).with_message(error_message)
    end
  end

  describe '.validate_deposit_term' do
    it 'returns the value when valid' do
      expect(described_class.validate_deposit_term(2.5)).to eq(2.5)
    end

    it 'raises when invalid' do
      error_message = 'Deposit term must be within 1-5 years'
      expect do
        described_class.validate_deposit_term(0.5)
      end.to raise_error(InvalidInputError).with_message(error_message)
    end
  end

  describe '.validate_interest_frequency' do
    it 'returns the value when valid' do
      expect(described_class.validate_interest_frequency(12)).to eq(12)
    end

    it 'raises when invalid' do
      error_message = 'Interest frequency must be one of monthly, quarterly, annually, maturity'
      expect do
        described_class.validate_interest_frequency(60)
      end.to raise_error(InvalidInputError).with_message(error_message)
    end
  end
end

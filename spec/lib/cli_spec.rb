# frozen_string_literal: true

require 'rspec'
require 'cli'

describe CLI do
  let(:args) { %w[1000 3.5 18 quarterly]}
  let(:expected_args) do
    {
      initial_deposit: 1000.0,
      interest_rate: 0.035,
      deposit_term: 1.5,
      interest_frequency: 4
    }
  end

  describe '#call' do
    it 'calls TermDepositCalculator with args' do
      calculator = instance_double(TermDepositCalculator)
      allow(TermDepositCalculator).to receive(:new).and_return(calculator)
      allow(calculator).to receive(:call)
      described_class.new.call(args)

      expect(calculator).to have_received(:call).with(expected_args)
    end
  end

  describe '.parse_initial_deposit' do
    it 'returns a float' do
      expect(described_class.parse_initial_deposit(10)).to eq(10.0)
    end
  end

  describe '.parse_interest_rate' do
    it 'returns a decimalised float' do
      expect(described_class.parse_interest_rate(10)).to eq(0.1)
    end
  end

  describe '.parse_deposit_term' do
    it 'returns a float of years' do
      expect(described_class.parse_deposit_term(18)).to eq(1.5)
    end
  end

  describe '.parse_interest_frequency' do
    it 'returns 12 for monthly' do
      expect(described_class.parse_interest_frequency('monthly')).to eq(12)
    end

    it 'returns 4 for quarterly' do
      expect(described_class.parse_interest_frequency('quarterly')).to eq(4)
    end

    it 'returns 1 for annually' do
      expect(described_class.parse_interest_frequency('annually')).to eq(1)
    end

    it 'returns 0 for maturity' do
      expect(described_class.parse_interest_frequency('maturity')).to eq(0)
    end

    it 'raises on unexpected frequency' do
      expect { described_class.parse_interest_frequency('unexpected') }.to raise_error.with_message('Unknown interest frequency')
    end
  end

end

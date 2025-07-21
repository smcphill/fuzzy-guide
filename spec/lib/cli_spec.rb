# frozen_string_literal: true

require 'rspec'
require 'cli'

describe CLI do
  let(:calculator) { instance_double(TermDepositCalculator) }
  let(:args) { %w[1000 3.5 18 quarterly] }
  let(:expected_args) do
    {
      initial_deposit: 1000.0,
      interest_rate: 0.035,
      deposit_term: 1.5,
      interest_frequency: 4
    }
  end

  describe '#call' do
    before do
      allow(TermDepositCalculator).to receive(:new).and_return(calculator)
      allow(calculator).to receive(:call).and_return([1035.0, 35.0])
    end

    it 'calls TermDepositCalculator with args' do
      described_class.new.call(args)

      expect(calculator).to have_received(:call).with(expected_args)
    end

    it 'calls .present_calculation with the calculation result' do
      allow(described_class).to receive(:present_calculation)

      described_class.new.call(args)
      expect(described_class).to have_received(:present_calculation).with(1035.0, 35.0)
    end
  end

  describe '.present_calculation' do
    let(:total) { 1035.0 }
    let(:interest) { 35.0 }

    before do
      allow(TermDepositCalculator).to receive(:new).and_return(calculator)
      allow(calculator).to receive(:call).and_return([total, interest])
    end

    it 'presents the calculated result' do
      expected_outcome = "    Final balance: $#{total.to_i}.00\n    Total interest earned:  $#{interest.to_i}.00\n"
      expect(described_class.present_calculation(total, interest)).to match(expected_outcome)
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
      expect do
        described_class.parse_interest_frequency('unexpected')
      end.to raise_error(ArgumentError).with_message('Unknown compounding frequency')
    end
  end
end

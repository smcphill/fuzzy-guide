# frozen_string_literal: true

require 'rspec'
require 'cli'

describe CLI do
  describe '#call' do
    let(:args) { %w[1000 3.5 12 1]}
    let(:expected_args) do
      {
        initial_deposit: 1000.0,
        interest_rate: 3.5,
        deposit_term: 12,
        interest_frequency: 1
      }
    end

    it 'calls TermDepositCalculator with args' do
      calculator = instance_double(TermDepositCalculator)
      allow(TermDepositCalculator).to receive(:new).and_return(calculator)
      allow(calculator).to receive(:call)
      described_class.new.call(args)

      expect(calculator).to have_received(:call).with(expected_args)
    end
  end
end

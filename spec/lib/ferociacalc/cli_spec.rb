# frozen_string_literal: true

require 'ferociacalc/cli'

describe Ferociacalc::CLI do
  describe '#calculate' do
    let(:args) { %w[1000 3.5 12 12].freeze }
    let(:expected_inputs) do
      {
        initial_deposit: 1000.0,
        interest_rate: 3.5,
        deposit_term: 12,
        interest_frequency: 12
      }
    end

    it 'calls calculator with expected arguments' do
      calculator = instance_double(Ferociacalc::TermDepositCalculator)
      allow(Ferociacalc::TermDepositCalculator).to receive(:new).and_return(calculator)
      allow(calculator).to receive(:call)

      described_class.new(args).calculate

      expect(calculator).to have_received(:call).with(**expected_inputs)
    end

  end
end

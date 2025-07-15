# frozen_string_literal: true

require 'ferociacalc/cli'

describe Ferociacalc::CLI do
  describe '#calculate' do
    let(:args) { %w[-d 1000 -i 3.5 -t 12 -p monthly].freeze }
    let(:expected_inputs) do
      {
        initial_deposit: 1000.0,
        interest_rate: 0.035,
        deposit_term: 1,
        interest_frequency: 12
      }
    end

    it 'calls calculator with expected arguments' do
      calculator = Ferociacalc::TermDepositCalculator.new
      allow(Ferociacalc::TermDepositCalculator).to receive(:new).and_return(calculator)
      allow(calculator).to receive(:call)

      described_class.new(args).calculate

      expect(calculator).to have_received(:call).with(**expected_inputs)
    end

  end
end

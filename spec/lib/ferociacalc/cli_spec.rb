# frozen_string_literal: true

require 'ferociacalc/cli'
require 'ferociacalc/result'

describe Ferociacalc::CLI do
  describe '#call' do
    let(:args) { %w[-d 1000 -i 3.5 -t 12 -p monthly].freeze }
    let(:expected_inputs) do
      {
        initial_deposit: 1000.0,
        interest_rate: 0.035,
        deposit_term: 1,
        interest_frequency: 12
      }
    end
    let(:result) { Ferociacalc::Result.new(1036.0, 36.0) }
    let(:calculator) { Ferociacalc::TermDepositCalculator.new }

    it 'calls calculator with expected arguments' do
      allow(Ferociacalc::TermDepositCalculator).to receive(:new).and_return(calculator)
      allow(calculator).to receive(:call).with(**expected_inputs).and_return(result)

      described_class.new(args).call

      expect(calculator).to have_received(:call).with(**expected_inputs)
    end
  end
end

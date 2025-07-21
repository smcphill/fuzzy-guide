# frozen_string_literal: true

require 'cli'

describe 'ferocioacalc integration tests' do # rubocop:disable RSpec/DescribeClass
  let(:banner) { "Usage: ferociacalc <initial> <rate_pa> <term_in_months> <compounding_frequency_per_year>\n" }

  let(:usage) do
    <<~HEREDOC
      Where:
      <initial>
      \tinitial deposit in $ e.g. 1000 for $1000
      <rate_pa>
      \tpercentage p.a. e.g. 3.5 for 3.5%
      <term_in_months>
      \tmonths for the deposit term e.g. 12 for 1 year
      <compounding_frequency_per_year>
      \tone of [monthly, quarterly, annually, maturity]
    HEREDOC
  end

  let(:given) do
    <<~HEREDOC
      Given:
      Initial deposit =$1000.00;
      Interest rate =3.5% per annum;
      Deposit term =12 months;
      Frequency =monthly times per annum (at maturity, there are 0 times per annum).)

    HEREDOC
  end

  it 'calculates correctly' do
    expected_output = "#{banner}#{usage}\n#{given}    Final balance: $1036.00\n    Total interest earned:  $36.00\n"

    expect { system('./bin/ferociacalc 1000 3.5 12 monthly') }.to output(expected_output).to_stdout_from_any_process
  end
end

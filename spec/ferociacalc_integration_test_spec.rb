# frozen_string_literal: true

describe 'ferocioacalc integration tests' do
  let(:help_output) do
    <<~HEREDOC
      Usage: ferociacalc <initial_deposit> <interest_rate> <deposit_term> <interest_frequency>

      initial_deposit:    Required Initial deposit amount in dollars ($1_000.00 - $1_500_000.00)
      interest_rate:    Required Interest rate % p.a (0-15; e.g. 3% is 3, not 0.03)
      deposit_term:    Required Deposit term in months (3-60; e.g. 12)
      interest_frequency:    Required Interest payment period (i.e. monthly, quarterly, annually, maturity)

      Exiting
    HEREDOC
  end

  it 'calculates correctly' do
    expected_output = "Final balance: $1036.00\nTotal interest earned:  $36.00\n"

    expect { system('./bin/ferociacalc 1000 3.5 12 monthly') }.to output(expected_output).to_stdout_from_any_process
  end

  it 'prints help' do
    expect { system('./bin/ferociacalc') }.to output(help_output).to_stdout_from_any_process
  end
end

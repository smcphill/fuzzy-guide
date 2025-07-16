# frozen_string_literal: true

describe 'ferocioacalc integration tests' do
  it 'calculates correctly' do
    expected_output = "Final balance: $1036.00\nTotal interest earned:  $36.00\n"

    expect { system('./bin/ferociacalc 1000 3.5 12 monthly') }.to output(expected_output).to_stdout_from_any_process
  end

end

# frozen_string_literal: true

describe 'ferocioacalc integration tests' do
  it 'calculates correctly' do
    expected_output = "Final balance: $1036.00\nTotal interest earned:  $36.00\n"

    expect { system('./bin/ferociacalc -d 1000 -i 3.5 -t 12 -p monthly') }.to output(expected_output).to_stdout_from_any_process
  end

end

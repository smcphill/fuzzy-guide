# frozen_string_literal: true

require 'cli'

describe "ferocioacalc integration tests" do
  it 'calculates correctly' do
    banner = "Usage: ferociacalc <initial> <rate_pa> <term_in_months> <compounding_frequency_per_year>\n"
    expected_output = "#{banner}    Final balance: $1036.00\n    Total interest earned:  $36.00\n"

    expect { system("./bin/ferociacalc 1000 3.5 12 12") }.to output(expected_output).to_stdout_from_any_process
  end

end

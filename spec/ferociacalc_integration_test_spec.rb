# frozen_string_literal: true

require 'mvp'

describe "ferocioacalc integration tests" do
  it 'calculates correctly' do
    expect { MVP.new.call }.to raise_error(NotImplementedError)
  end

end

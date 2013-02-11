require 'spec_helper'

describe Simulation do
  subject { FactoryGirl.create(:stock).simulations.new }
  it { should respond_to(:simulation_logs) }
end

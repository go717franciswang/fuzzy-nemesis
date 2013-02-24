class AddColumnFreqToSimulationScenarios < ActiveRecord::Migration
  def change
    add_column :simulation_scenarios, :frequency, :integer
    add_column :simulation_scenarios, :frequency_type, :string
  end
end

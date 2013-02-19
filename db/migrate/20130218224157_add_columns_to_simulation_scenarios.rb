class AddColumnsToSimulationScenarios < ActiveRecord::Migration
  def change
    add_column :simulation_scenarios, :action, :string
    add_column :simulation_scenarios, :amount, :float
    add_column :simulation_scenarios, :unit, :string
    add_column :simulation_scenarios, :operator, :string
    add_column :simulation_scenarios, :stat, :string
    add_column :simulation_scenarios, :timespan_length, :integer
    add_column :simulation_scenarios, :timespan_unit, :string
    remove_column :simulation_scenarios, :scenario_id
  end
end

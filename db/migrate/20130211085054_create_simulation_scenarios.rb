class CreateSimulationScenarios < ActiveRecord::Migration
  def change
    create_table :simulation_scenarios do |t|
      t.integer :simulation_id
      t.integer :scenario_id

      t.timestamps
    end
  end
end

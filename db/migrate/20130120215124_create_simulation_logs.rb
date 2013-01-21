class CreateSimulationLogs < ActiveRecord::Migration
  def change
    create_table :simulation_logs do |t|
      t.integer :simulation_id
      t.date :date_at
      t.float :fund
      t.integer :share
      t.float :net_value
      t.string :event

      t.timestamps
    end
  end
end

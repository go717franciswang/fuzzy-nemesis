class DropHistoricalPricesAndSimulationLogs < ActiveRecord::Migration
  def up
    drop_table :historical_prices
    drop_table :simulation_logs
  end

  def down
  end
end

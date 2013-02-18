class AddMoreFieldToHistoricalPrices < ActiveRecord::Migration
  def change
    add_column :historical_prices, :volume, :integer
    add_column :historical_prices, :adj_close, :float
  end
end

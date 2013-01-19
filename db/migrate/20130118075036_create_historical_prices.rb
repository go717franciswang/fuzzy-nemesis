class CreateHistoricalPrices < ActiveRecord::Migration
  def change
    create_table :historical_prices do |t|
      t.integer :stock_id
      t.date :date_at
      t.float :high
      t.float :low
      t.float :open
      t.float :close

      t.timestamps
    end
    add_index :historical_prices, [:stock_id, :date_at], unique: true
  end
end

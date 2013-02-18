class AddRefreshedAtToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :refreshed_at, :datetime
  end
end

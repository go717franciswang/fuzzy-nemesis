class CreateSimulations < ActiveRecord::Migration
  def change
    create_table :simulations do |t|
      t.integer :stock_id

      t.timestamps
    end
  end
end

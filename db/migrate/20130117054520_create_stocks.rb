class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :quote

      t.timestamps
    end
    add_index :stocks, :quote, unique: true
  end
end

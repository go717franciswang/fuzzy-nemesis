class AddStartSharesToSimulations < ActiveRecord::Migration
  def change
    add_column :simulations, :start_shares, :integer
  end
end

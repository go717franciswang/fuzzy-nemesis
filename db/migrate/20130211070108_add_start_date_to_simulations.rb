class AddStartDateToSimulations < ActiveRecord::Migration
  def change
    add_column :simulations, :start_date, :date
    add_column :simulations, :end_date, :date
    add_column :simulations, :start_amount, :float
    add_column :simulations, :annuity, :float
    add_column :simulations, :annuity_freq_id, :integer
  end
end

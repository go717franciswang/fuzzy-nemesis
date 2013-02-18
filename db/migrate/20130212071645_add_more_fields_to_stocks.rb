class AddMoreFieldsToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :start_date, :date
    add_column :stocks, :end_date, :date
    add_column :stocks, :sector, :string
    add_column :stocks, :industry, :string
    add_column :stocks, :full_time_employees, :integer
  end
end

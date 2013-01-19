class HistoricalPrice < ActiveRecord::Base
  attr_accessible :close, :date_at, :high, :low, :open

  belongs_to :stock
end

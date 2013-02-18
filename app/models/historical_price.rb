class HistoricalPrice < ActiveRecord::Base
  attr_accessible :close, :date_at, :high, :low, :open,
    :volume, :adj_close

  belongs_to :stock
end

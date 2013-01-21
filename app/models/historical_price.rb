class HistoricalPrice < ActiveRecord::Base
  attr_accessible :close, :date_at, :high, :low, :open

  belongs_to :stock

  default_scope order('date_at desc')
end

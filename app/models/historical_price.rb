class HistoricalPrice
  include Mongoid::Document
  include Mongoid::Timestamps

  field :stock_id, type: Integer
  field :close, type: Float
  field :date_at, type: Date
  field :high, type: Float
  field :low, type: Float
  field :open, type: Float
  field :volume, type: Integer
  field :adj_close, type: Float

  index({ stock_id: 1, date_at: 1 }, { unique: true })

  def stock
    Stock.find(self.stock_id)
  end
end

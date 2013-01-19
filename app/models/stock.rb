class Stock < ActiveRecord::Base
  attr_accessible :name, :quote
  has_many :historical_prices, dependent: :destroy
  validates :name, presence: true
  validates :quote, presence: true
end

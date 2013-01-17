class Stock < ActiveRecord::Base
  attr_accessible :name, :quote
  validates :name, presence: true
  validates :quote, presence: true
end

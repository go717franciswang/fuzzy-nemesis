class Simulation < ActiveRecord::Base
  attr_accessible :stock_id
  has_many :simulation_logs, dependent: :destroy
  belongs_to :stock
end

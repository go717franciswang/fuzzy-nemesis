class Scenario < ActiveRecord::Base
  attr_accessible :name
  has_many :simulation_scenarios
  has_many :simulations, through: :simulation_scenarios
end

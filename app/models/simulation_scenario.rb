class SimulationScenario < ActiveRecord::Base
  attr_accessible :scenario_id, :simulation_id
  belongs_to :simulation
  belongs_to :scenario
end

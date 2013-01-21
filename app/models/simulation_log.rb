class SimulationLog < ActiveRecord::Base
  attr_accessible :date_at, :event, :fund, 
    :net_value, :share, :simulation_id
  belongs_to :simulation
end

class SimulationLog
  include Mongoid::Document
  include Mongoid::Timestamps

  field :simulation_id, type: Integer
  field :date_at, type: Date
  field :event, type: String
  field :fund, type: Float
  field :net_value, type: Float
  field :share, type: Integer
  field :criterias, type: Array

  index({ simulation_id: 1, date_at: 1 }, { unique: true })

  def simulation
    Simulation.find(self.simulation_id)
  end
end

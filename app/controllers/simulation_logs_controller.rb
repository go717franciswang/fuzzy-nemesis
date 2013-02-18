class SimulationLogsController < ApplicationController
  def index
    @simulation = Simulation.find(params[:id])
    @simulation_logs = @simulation.simulation_logs.paginate(
      page: params[:page]
    )
  end
end

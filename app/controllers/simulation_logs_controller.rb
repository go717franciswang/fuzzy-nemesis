class SimulationLogsController < ApplicationController
  def show
    @simulation = Simulation.find(params[:id])
    @simulation_logs = @simulation.simulation_logs.asc(:date_at).
      page(params[:page]).per(50)
  end
end

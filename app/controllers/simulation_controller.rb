class SimulationController < ApplicationController
  def new
    @stock = Stock.find(params[:id])
    @simulation = @stock.simulations.new
  end

  def create
  end
end

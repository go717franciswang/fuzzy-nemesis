class SimulationController < ApplicationController
  def new
    @stock = Stock.find(params[:id])
  end

  def create
  end
end

class SimulationController < ApplicationController
  def new
    @stock = Stock.find(params[:id])
    @simulation = @stock.simulations.new    
    @annuity_freq_types = AnnuityFreqType.all
  end

  def create
  end
end

class SimulationsController < ApplicationController
  def new
    @stock = Stock.find(params[:id])
    @simulation = @stock.simulations.new    
    @annuity_freq_types = AnnuityFreqType.all
  end

  def create
    @stock = Stock.find(params[:id])
    @simulation = @stock.simulations.build(params[:simulation])
    if @simulation.save
      SIMULATION_QUEUE << @simulation.id
      flash[:success] = "Simulation has been successfully queued"
      redirect_to simulations_stock_path(@simulation.stock_id)
      # @annuity_freq_types = AnnuityFreqType.all
      # render 'new'
    else
      redirect_to simulate_stock_path(@simulation.stock_id)
    end
  end

  def index
    if params[:id]
      @stock = Stock.find(params[:id])
      @subject_name = @stock.name
      @simulations = @stock.simulations.find(
        :all, 
        include: [:annuity_freq_type, :stock]
      )
    else
      @subject_name = 'All'
      @simulations = Simulation.find(
        :all, 
        include: [:annuity_freq_type, :stock]
      )
    end
  end
end

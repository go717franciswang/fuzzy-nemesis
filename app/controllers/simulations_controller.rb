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
      @annuity_freq_types = AnnuityFreqType.all
      render 'new'
    end
  end

  def index
    if params[:id]
      @stock = Stock.find(params[:id])
      @subject_name = @stock.name
      @simulations = @stock.simulations.find(
        :all, 
        include: [:annuity_freq_type, :stock]
      ).reverse
    else
      @subject_name = 'All'
      @simulations = Simulation.find(
        :all, 
        include: [:annuity_freq_type, :stock]
      ).reverse
    end
  end

  def destroy
    @simulation = Simulation.find(params[:id])
    @simulation.destroy
    flash[:success] = "Simulation was deleted"
    redirect_to simulations_path
  end
end

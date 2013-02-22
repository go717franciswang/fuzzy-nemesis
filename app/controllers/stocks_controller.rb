class StocksController < ApplicationController
  def index
    @stocks = Stock.paginate(page: params[:page])
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(params[:stock])
    if @stock.save
      @stock.refresh
      flash[:success] = "Company #{@stock.name} has been successfully "\
        "registered, additional info will be automatically queried "\
        "from Yahoo"
      redirect_to stocks_path
    else
      render 'new'
    end
  end

  def show
    @stock = Stock.find(params[:id])
    @prices = @stock.historical_prices.order('date_at desc').paginate(
      page: params[:page]
    )
  end

  def refresh
    @stock = Stock.find(params[:id])
    @stock.refresh
    flash[:notice] = "Company info of #{@stock.name} will be "\
      "refreshed shortly"
    redirect_to stocks_path
  end

  def destroy
    @stock = Stock.find(params[:id])
    msg = "Company #{@stock.name} have been deleted"
    @stock.destroy
    flash[:success] = msg
    redirect_to stocks_path
  end
end

class StocksController < ApplicationController
  def index
    @stocks = Stock.paginate(page: params[:page])
  end

  def show
    @stock = Stock.find(params[:id])
    @prices = @stock.historical_prices.paginate(
      page: params[:page]
    )
  end
end

class StocksController < ApplicationController
  def index
    @stocks = Stock.paginate(page: params[:page])
  end
end

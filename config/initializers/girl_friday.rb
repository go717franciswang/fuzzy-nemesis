STOCK_QUEUE = GirlFriday::WorkQueue.new(:stock_id, size: 1) do |msg|
  stock = Stock.find(msg)
  if stock
    stock.retrieve_company_info 
    stock.retrieve_historical_prices
  end
end

SIMULATION_QUEUE = GirlFriday::WorkQueue.new(:simulation_id, size: 1) do |msg|
  simulation = Simulation.find(msg)
  if simulation
    simulation.simulate
  end
end

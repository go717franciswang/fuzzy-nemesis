namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    100.times do |n|
      name = Faker::Company.name
      quote = "#{Faker::Company.suffix}_#{n}"
      Stock.create!(name: name, quote: quote)
    end

    stocks = Stock.all(limit: 6)
    50.times do |n|
      date_at = (Date.today - n).to_s
      stocks.each do |stock|
        high = Random.rand*100
        low = high - Random.rand*100
        open = low + (high - low)*Random.rand
        close = low + (high - low)*Random.rand
        stock.historical_prices.create!(
          date_at: date_at,
          high: high,
          low: low,
          open: open,
          close: close 
        )
      end
    end
  end
end

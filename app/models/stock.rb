class Stock < ActiveRecord::Base
  attr_accessible :name, :quote
  has_many :historical_prices, dependent: :destroy
  has_many :simulations, dependent: :destroy
  validates :name, presence: true
  validates :quote, presence: true

  def simulate(start_date, end_date, sfund, sshare, logics = [])
    simulation = simulations.create
    
    prices = historical_prices.where(
      'date_at >= ? and date_at <= ?', start_date, end_date
    ).order('date_at asc')

    fund = sfund
    share = sshare

    prices.each do |price|
      date_at = price.date_at
      stock_id = price.stock_id
      value = fund + share * price.close
      event = nil
      simulation.simulation_logs.build(
        date_at: date_at,
        fund: fund,
        share: share,
        net_value: value,
        event: event
      )
    end

    simulation.save
  end
end

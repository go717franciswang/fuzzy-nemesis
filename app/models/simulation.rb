class Simulation < ActiveRecord::Base
  attr_accessible :stock_id, :start_date, :end_date, :start_amount,
    :annuity, :annuity_freq_type_id, :simulation_scenarios, :scenarios,
    :start_shares
  has_many :simulation_logs, dependent: :destroy
  belongs_to :annuity_freq_type
  has_many :simulation_scenarios, dependent: :destroy
  has_many :scenarios, through: :simulation_scenarios
  belongs_to :stock

  after_initialize :after_initialize

  def after_initialize
    return unless self.new_record?
    self.start_date ||= self.stock.earliest_date
    self.end_date ||= Date.today - 1
    self.start_amount ||= 100
    self.start_shares ||= 0
    self.annuity ||= 0
    self.annuity_freq_type_id ||= AnnuityFreqType.last.id
  end

  def simulate
    SimulationLog.where(simulation_id: self.id).delete_all
    prices = self.stock.historical_prices.where(
      'date_at >= ? and date_at <= ?', 
      self.start_date, 
      self.end_date
    ).order('date_at asc')

    fund = self.start_amount
    share = self.start_shares
    annuity_schedule = AnnuitySchedule.new(
      self.start_date, self.annuity_freq_type
    )
    annuity_deposit_date = annuity_schedule.next_deposit_date

    prices.each do |price|
      date_at = price.date_at
      # puts "date_at: #{date_at}"
      # puts "annuity_deposit_date: #{annuity_deposit_date}"
      stock_id = price.stock_id
      value = fund + share * price.close
      event = []
      if price == prices.first
        event << :START
      end
      if price == prices.last
        event << :END
      end
      if annuity_deposit_date <= date_at
        event << :ANNUITY
        fund += self.annuity
        annuity_deposit_date = annuity_schedule.next_deposit_date
      end
      self.simulation_logs.build(
        date_at: date_at,
        fund: fund,
        share: share,
        net_value: value,
        event: event.join(', ')
      )
    end

    self.save
  end
end

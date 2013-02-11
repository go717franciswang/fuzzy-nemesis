class Simulation < ActiveRecord::Base
  attr_accessible :stock_id, :start_date, :end_date, :start_amount,
    :annuity, :annuity_freq_type_id, :simulation_scenarios, :scenarios
  has_many :simulation_logs, dependent: :destroy
  has_one :annuity_freq
  has_many :simulation_scenarios, dependent: :destroy
  has_many :scenarios, through: :simulation_scenarios
  belongs_to :stock

  after_initialize :after_initialize

  def after_initialize
    return unless self.new_record?
    self.start_date = self.stock.earliest_date
    self.end_date = Date.today - 1
    self.start_amount = 100
    self.annuity = 0
    self.annuity_freq_id = AnnuityFreqType.last.id
  end
end

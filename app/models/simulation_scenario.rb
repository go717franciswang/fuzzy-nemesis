class SimulationScenario < ActiveRecord::Base
  attr_accessible :simulation_id, :action, :amount,
    :unit, :operator, :stat, :timespan_length, :timespan_unit

  validates :action, presence: true, inclusion: { in: %w( Buy Sell ) }
  validates :amount, presence: true, 
    numericality: { greater_than_or_equal_to: 0}
  validates :unit, presence: true, inclusion: { in: 
    %w( Shares Dollar_shares Pcg_of_fund Pcg_of_shares ) }
  validates :operator, presence: true, inclusion: { in: %w( Gt_eq Lt_eq ) }
  validates :stat, presence: true, inclusion: { in: %w( Max Min Avg ) }
  validates :timespan_length, presence: true, 
    numericality: { only_integer: true }
  validates :timespan_unit, presence: true, inclusion: 
    { in: %w( Days Weeks Months Quarters Years ) }

  belongs_to :simulation
end

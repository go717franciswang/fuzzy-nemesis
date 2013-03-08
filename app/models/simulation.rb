class Simulation < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  attr_accessible :stock_id, :start_date, :end_date, :start_amount,
    :annuity, :annuity_freq_type_id, :simulation_scenarios_attributes,
    :start_shares
  has_many :simulation_scenarios, dependent: :destroy
  belongs_to :annuity_freq_type
  accepts_nested_attributes_for :simulation_scenarios, allow_destroy: true
  # has_many :scenarios, through: :simulation_scenarios
  belongs_to :stock

  after_initialize :after_initialize
  before_destroy :destroy_simulation_logs

  def after_initialize
    return unless self.new_record?
    self.start_date ||= self.stock.earliest_date
    self.end_date ||= Date.today - 1
    self.start_amount ||= 100
    self.start_shares ||= 0
    self.annuity ||= 0
    self.annuity_freq_type_id ||= AnnuityFreqType.last.id
    if self.simulation_scenarios.empty?
      # self.simulation_scenarios.build(action: 'Buy')
      # self.simulation_scenarios.build(action: 'Sell')
    end
  end

  def simulate
    self.destroy_simulation_logs
    statistics = Statistics.new(self.start_date, self.end_date, 
                           self.stock_id, self.simulation_scenarios)

    fund = self.start_amount.to_f
    share = self.start_shares.to_f
    annuity_schedule = AnnuitySchedule.new(
      self.start_date, self.annuity_freq_type
    )
    annuity_deposit_date = annuity_schedule.next_deposit_date

    scenarios_tracker = ScenariosTracker.new(
      self.simulation_scenarios, self.start_date
    )

    statistics.prices.asc(:date_at).each do |price|
      date_at = price.date_at
      next if date_at < statistics.report_start_date
      # puts "date_at: #{date_at}"
      # puts "annuity_deposit_date: #{annuity_deposit_date}"
      stock_id = price.stock_id
      event = []
      if price == statistics.report_start_date
        event << :Start
      end
      if price == statistics.report_end_date
        event << :End
      end
      if self.annuity > 0.0 and annuity_deposit_date <= date_at
        event << :Deposit
        fund += self.annuity
        annuity_deposit_date = annuity_schedule.next_deposit_date
      end
      self.simulation_scenarios.each do |scenario|
        next unless scenarios_tracker.time_to_act_on?(scenario, date_at)
        
        stat = statistics.get_stat(scenario[:stat], date_at, 
             scenario[:timespan_length], scenario[:timespan_unit])
        next unless stat
        # puts "date_at: #{date_at}"
        # puts "stat type: #{scenario[:stat]}"
        # puts "timespan_length: #{scenario[:timespan_length]}"
        # puts "timespan_unit: #{scenario[:timespan_unit]}"
        # puts "stat: #{stat}"
        case scenario[:operator].to_sym
        when :Gt_eq
          take_action = (price[:low] <= stat)
        when :Lt_eq
          take_action = (price[:high] >= stat)
        end

        if take_action
          dollar_amount = case scenario[:unit].to_sym
          when :Shares
            scenario[:amount] * stat
          when :Dollar_shares
            scenario[:amount]
          when :Pcg_of_fund
            scenario[:amount].to_f / 100 * fund
          when :Pcg_of_shares
            scenario[:amount].to_f / 100 * shares * stat
          end
          # puts "unit: #{scenario[:unit]}"
          # puts "dollar_amount: #{dollar_amount}"
          # puts "fund: #{fund}"

          stat = price[:high] if stat > price[:high]
          stat = price[:low] if stat < price[:low]
          case scenario[:action].to_sym
          when :Buy
            dollar_amount = fund if dollar_amount > fund
            dollar_amount -= dollar_amount % stat
            fund -= dollar_amount
            share_delta = dollar_amount / stat
          when :Sell
            dollar_amount = share * stat if dollar_amount < share * stat
            dollar_amount -= dollar_amount % stat
            fund += dollar_amount
            share_delta = -dollar_amount / stat
          end

          share += share_delta
          scenarios_tracker.act_on(scenario, date_at)
          event << "#{scenario[:action]} #{pluralize(share_delta.round, 'share')}"
        end
      end
      unless event.empty?
        value = fund + share * price.close
        log = self.simulation_logs.build
        log[:date_at] = date_at
        log[:fund] = fund
        log[:share] = share
        log[:net_value] = value
        log[:event] = event.join(', ')
        log.save
      end
    end

  end

  def simulation_logs
    SimulationLog.where(simulation_id: self.id)
  end

  def destroy_simulation_logs
    self.simulation_logs.delete
  end
end

class Statistics
  extend ActiveSupport::Memoizable
  attr_reader :prices, :report_start_date, :report_end_date

  def initialize(start_date, end_date, stock_id, scenarios)
    @start_date = start_date
    @end_date = end_date
    @scenarios = scenarios
    @prices = Stock.find(stock_id).historical_prices.where(
      'date_at >= ? and date_at <= ?', 
      self.stat_start_date, 
      @end_date
    ).order('date_at asc')
    @date_prices = {}
    @report_start_date = nil
    @prices.each do |price|
      if @report_start_date.nil? and price.date_at >= @start_date
        @report_start_date = price.date_at 
      end
      @date_prices[price.date_at] = price
    end
    @report_end_date = @prices.last.date_at
  end

  def get_stat(stat, date_at, last_n, timespan_unit)
    date_range = self.get_date_range(date_at, last_n, timespan_unit)
    self.get_stat_of_range(stat, date_range)
  end

  def get_stat_of_range(stat, date_range)
    answer = nil
    case stat.to_sym
    when :Max
      date_range.each do |date|
        price = @date_prices[date]
        next unless price
        answer = price[:high] if answer.nil? || price[:high] > answer
      end
    when :Min
      date_range.each do |date|
        price = @date_prices[date]
        next unless price
        answer = price[:low] if answer.nil? || price[:low] < answer
      end
    when :Avg
      total_vol = 0
      date_range.each do |date|
        price = @date_prices[date]
        next unless price
        answer ||= 0
        answer += self.avg(price) * price[:volume]
        total_vol += price[:volume]
      end
      answer /= total_vol
    end
    answer
  end

  def get_date_range(date_at, last_n, timespan_unit)
    case timespan_unit.to_sym
    when :Days
      (date_at - last_n)..(date_at - 1)
    when :Weeks
      (date_at.weeks_ago(last_n).beginning_of_week)..
        (date_at.weeks_ago(1).end_of_week)
    when :Months
      (date_at.months_ago(last_n).beginning_of_month)..
        (date_at.months_ago(1).end_of_month)
    when :Quarters
      (date_at.months_ago(last_n * 3).beginning_of_quarter)..
        (date_at.months_ago(3).end_of_quarter)
    when :Years
      (date_at.years_ago(last_n).beginning_of_year)..
        (date_at.years_ago(1).end_of_year)
    end
  end

  def stat_start_date
    scenario_sdates = [@start_date]
    @scenarios.each do |scenario|
      scenario_sdates << self.get_date_range(@start_date, 
                          scenario[:timespan_length], 
                          scenario[:timespan_unit]).first
    end
    scenario_sdates.min
  end

  def avg(price)
    (price[:open] + price[:close]) / 2
  end

  memoize :stat_start_date, :get_date_range, :get_stat_of_range
end

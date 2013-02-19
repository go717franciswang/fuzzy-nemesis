require 'uri'
require 'open-uri'
require "json"

class Stock < ActiveRecord::Base
  attr_accessible :name, :quote, :start_date, :end_date,
    :sector, :industry, :full_time_employees, :refreshed_at
  has_many :historical_prices, dependent: :destroy
  has_many :simulations, dependent: :destroy
  validates :name, presence: true
  validates :quote, presence: true

  def earliest_date
    last_record = self.historical_prices.order('date_at desc').last
    return Date.today - 1 unless last_record
    return last_record.date_at if last_record
  end

  def retrieve_company_info
    query = "select * from yahoo.finance.stocks 
      where symbol = \"#{self.quote}\";"
    url = "http://query.yahooapis.com/v1/public/yql?q="\
      "#{URI::escape(query)}&format=json&diagnostics="\
      "false&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
    json = open(url).read
    data = JSON::load(json)
    return unless data && data['query'] && data['query']['results']
    result = data['query']['results']['stock']
    # puts "result: #{result}"
    self.name = result['CompanyName'].presence || self.name 
    self.start_date = result['start'] || self.start_date
    self.end_date = result['end'] || self.end_date
    self.sector = result['Sector'] || self.sector
    self.industry = result['Industry'] || self.industry
    if result['FullTimeEmployees'] && result['FullTimeEmployees'] != 'N/A'
      self.full_time_employees = result['FullTimeEmployees'].to_i
    end
    # puts "#{self.start_date}"
    # puts "#{self.end_date}"
    # puts "#{self.sector}"
    # puts "#{self.industry}"
    # puts "#{self.full_time_employees}"
    self.save
  end

  def retrieve_historical_prices
    last_entry = self.historical_prices.first
    if last_entry
      start_at = last_entry.dup.date_at
      # make sure the last record is refreshed in case it 
      # was refreshed in the middle of the day
      last_entry.delete
    elsif self.start_date
      start_at = self.start_date
    else
      return
    end
    batch_size = 100
    columns = [:stock_id, :date_at, :high, :low, 
               :open, :close, :volume, :adj_close]
    end_at = [start_at + batch_size, self.end_date].min

    # puts "start_at: #{start_at}"
    # puts "end_at: #{end_at}"
    # puts "end date: #{self.end_date}"
    while start_at < self.end_date
      query = "select * from yahoo.finance.historicaldata 
        where symbol = \"#{self.quote}\" and startDate = 
        \"#{start_at.strftime('%Y-%m-%d')}\" and endDate = 
        \"#{end_at.strftime('%Y-%m-%d')}\";"
      url = "http://query.yahooapis.com/v1/public/yql?q="\
        "#{URI::escape(query)}&format=json&diagnostics="\
        "false&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
      # puts "url: #{url}"
      json = open(url).read
      data = JSON::load(json)
      if data && data['query'] && data['query']['results']
        prices = data['query']['results']['quote'] 
        rows = []
        prices.each do |price|
          # puts "date: #{price['Date']}"
          rows << [
            self.id,
            price['Date'],
            price['High'],
            price['Low'],
            price['Open'],
            price['Close'],
            price['Volume'],
            price['Adj_Close'],
          ]
        end
        HistoricalPrice.import columns, rows, validate: false
      end
      start_at += (batch_size + 1)
      end_at = [start_at + batch_size, self.end_date].min
    end
  end

  def refresh
    self.refreshed_at = Time.now
    self.save
    STOCK_QUEUE << self.id
  end

  def refreshed_today?
    return false unless self.refreshed_at
    return self.refreshed_at.to_date == Date.today
  end
end

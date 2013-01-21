require 'spec_helper'

describe "StockPages" do
  
  subject { page }

  describe "index page" do
    before(:each) do
      31.times { FactoryGirl.create(:stock) }
      visit stocks_path
    end

    it "should have pagination" do
      should have_selector('div.pagination')
    end

    it "should list each company" do
      Stock.all(limit: 30).each do |stock|
        should have_selector('li', text: stock.name)
      end
    end

    it "should list link to each company stock page" do
      Stock.all(limit: 30).each do |stock|
        should have_link(stock.name, href: stock_path(stock))
      end
    end

    it "should list link to simulate each stock" do
      Stock.all(limit: 30).each do |stock|
        should have_link('simulate', 
                         href: simulate_stock_path(stock))
      end
    end
  end

  describe "show page" do
    let(:stock) { FactoryGirl.create(:stock) }
    before(:each) do
      visit stock_path(stock)
    end
    
    it "should display company name" do
      should have_content(stock.name)
    end
    describe "pagination" do
      before(:all) do
        31.times { FactoryGirl.create(:historical_price,
                                      stock: stock) }
        visit stock_path(stock)
      end
      
      it "should description" do
        should have_selector('div.pagination')
      end
      it "should have" do
        stock.historical_prices[0..29].each do |p|
          page.should have_selector('td', text: p.date_at.to_s)
        end
      end

      after(:all) do
        stock.historical_prices = []
        stock.save!
        stock.destroy
      end
    end

    it "should have prices displayed in 2 decimal places" do
      price = FactoryGirl.create(:historical_price,
                                 stock: stock,
                                 high: 1.111,
                                 low: 1.115)
      visit stock_path(stock)
      should have_selector('td', text: '1.11')
      should have_selector('td', text: '1.12')
    end
  end
end

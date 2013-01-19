require 'spec_helper'

describe "StockPages" do
  
  subject { page }

  describe "index page" do

    describe "pagination" do
      before(:all) do 
        31.times { FactoryGirl.create(:stock) }
        visit stocks_path
      end
      after(:all) do
        Stock.delete_all
      end
      

      it { should have_selector('div.pagination') }
      it "should list each company" do
        Stock.all do |stock|
          should have_selector('li', text: stock.name)
        end
      end
      it "should have link to the company show page" do
        Stock.all do |stock|
          should have_link(stock.name, href: stock_path(stock))
        end
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
      after(:all) do
        stock.historical_prices = []
        stock.save!
      end
      
      it "should description" do
        should have_selector('div.pagination')
      end
      it "should have" do
        stock.historical_prices[0..29].each do |p|
          page.should have_selector('td', text: p.date_at.to_s)
        end
      end
    end
  end
end

require 'spec_helper'

describe "StockPages" do
  
  subject { page }

  before(:each) { visit stocks_path }

  describe "index" do

    describe "pagination" do
      before(:all) { 31.times { FactoryGirl.create(:stock) }}
      after(:all) { Stock.delete_all }

      it { should have_selector('div.pagination') }
      it "should list each user" do
        Stock.all do |stock|
          page.should have_selector('li', text: stock.name)
        end
      end
    end
  end
end

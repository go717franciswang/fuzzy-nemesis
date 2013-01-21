require 'spec_helper'

describe "Simulations" do

  subject { page }

  let(:stock) { FactoryGirl.create(:stock) }

  describe "simulate page" do
    it "should display content simulate stock name" do
      visit simulate_stock_path(stock)
      should have_selector('h1', text: "Simulate #{stock.name}")
    end
  end
end

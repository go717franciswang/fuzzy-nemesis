require 'spec_helper'

describe Stock do

  let(:stock) { FactoryGirl.create(:stock) }
  subject { stock }

  it { should respond_to(:name) }
  it { should respond_to(:quote) }
  it { should respond_to(:historical_prices) }

  it { should be_valid }

  describe "when name is not present" do
    before { stock.name = " " }
    it { should_not be_valid }
  end

  describe "when quote is not present" do
    before { stock.quote = " " }
    it { should_not be_valid }
  end

  describe "associated historical prices" do
    before do
      FactoryGirl.create(:historical_price, stock: stock)
    end
    it "deleting the stock would also delete prices" do
      stock.destroy
      prices = stock.historical_prices.dup
      prices.each do |price|
        describe "should not exist" do
          HistoricalPrice.find_by_id(price.id).should be_nil
        end
      end
    end
  end
end

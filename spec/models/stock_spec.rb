require 'spec_helper'

describe Stock do

  let(:stock) { FactoryGirl.create(:stock) }
  subject { stock }

  it { should respond_to(:name) }
  it { should respond_to(:quote) }
  it { should respond_to(:historical_prices) }
  it { should respond_to(:simulate) }
  it { should respond_to(:simulations) }

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
    it "deleting the stock would also delete prices" do
      FactoryGirl.create(:historical_price, stock: stock)
      stock.destroy
      prices = stock.historical_prices.dup
      prices.each do |price|
        describe "should not exist" do
          HistoricalPrice.find_by_id(price.id).should be_nil
        end
      end
    end
    it "should fetch prices in dated order" do
      older_price = FactoryGirl.create(:historical_price,
                                         stock: stock,
                                         date_at: '2013-01-01')
      newer_price = FactoryGirl.create(:historical_price,
                                         stock: stock,
                                         date_at: '2013-01-02')
      stock.historical_prices.should eq(
        [newer_price, older_price]
      )
    end
  end

  describe "run simulation" do
    it "should create a new simulation" do
      expect { stock.simulate('2012-01-01','2012-01-01',0,0) }.
        to change(Simulation, :count).by(1)
    end
  end
end

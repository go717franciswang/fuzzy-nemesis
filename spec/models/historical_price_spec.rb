require 'spec_helper'

describe HistoricalPrice do
  let(:stock) { FactoryGirl.create(:stock) }
  let(:price) do 
    FactoryGirl.create(:historical_price, stock: stock) 
  end

  subject { price }

  it { should respond_to(:stock) }
  it { should respond_to(:date_at) }
  it { should respond_to(:high) }
  it { should respond_to(:low) }
  it { should respond_to(:open) }
  it { should respond_to(:close) }
end

require 'spec_helper'

describe Stock do

  let(:stock) { FactoryGirl.create(:stock) }
  subject { stock }

  it { should respond_to(:name) }
  it { should respond_to(:quote) }

  it { should be_valid }

  describe "when name is not present" do
    before { stock.name = " " }
    it { should_not be_valid }
  end

  describe "when quote is not present" do
    before { stock.quote = " " }
    it { should_not be_valid }
  end
end

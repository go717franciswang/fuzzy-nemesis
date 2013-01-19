FactoryGirl.define do
  factory :stock do
    sequence(:name) { |n| "Test Stock #{n}" }
    sequence(:quote) { |n| "TS_#{n}" }
  end

  factory :historical_price do
    stock
    sequence(:date_at) { |n| (Date.today - n).strftime }
    high 1.0
    low 0.0
    open 0.0
    close 1.0
  end
end

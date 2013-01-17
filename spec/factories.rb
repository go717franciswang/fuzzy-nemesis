FactoryGirl.define do
  factory :stock do
    sequence(:name) { |n| "Test Stock #{n}" }
    sequence(:quote) { |n| "TS_#{n}" }
  end
end

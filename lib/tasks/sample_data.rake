namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    100.times do |n|
      name = Faker::Company.name
      quote = "#{Faker::Company.suffix}_#{n}"
      Stock.create!(name: name, quote: quote)
    end
  end
end

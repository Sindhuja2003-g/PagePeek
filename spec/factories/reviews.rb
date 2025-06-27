FactoryBot.define do
  factory :review do
    rating { rand(1..5) }
    review { Faker::Lorem.paragraph }
    association :user
    association :book
  end
end

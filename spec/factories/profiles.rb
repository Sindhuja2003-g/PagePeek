FactoryBot.define do
  factory :profile do
    bio { Faker::Quote.matz }
    location { Faker::Address.city }
    association :user
  end
end

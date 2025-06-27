FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(specifier: 5..10) }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    role { :user }

    trait :moderator do
      role { :moderator }
    end
  end
end
# spec/factories/genres.rb
FactoryBot.define do
  factory :genre do
    name { Faker::Book.genre }  # e.g., "Science Fiction", "Romance"
  end
end

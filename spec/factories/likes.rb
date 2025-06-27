FactoryBot.define do
  factory :like do
    association :user
    association :likeable, factory: :book  # default to a Book; can be overridden
  end
end

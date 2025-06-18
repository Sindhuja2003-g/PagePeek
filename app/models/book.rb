class Book < ApplicationRecord
  has_and_belongs_to_many :genres
  has_many :reviews ,dependent: :destroy
  has_many :likes, as: :likeable,dependent: :destroy
 has_many :reviewing_users, through: :reviews, source: :user
end

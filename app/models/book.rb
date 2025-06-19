class Book < ApplicationRecord
  has_and_belongs_to_many :genres
  has_many :reviews ,dependent: :destroy
  has_many :likes, as: :likeable,dependent: :destroy

end

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :likes, as: :likeable,dependent: :destroy
  scope :top_rated, -> { order(rating: :desc, created_at: :desc) }
end

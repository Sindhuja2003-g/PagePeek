class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :likes, as: :likeable,dependent: :destroy

  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  scope :top_rated, -> { order(rating: :desc, created_at: :desc) }
  
  include Ransackable
end


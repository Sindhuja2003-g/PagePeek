class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :likes, as: :likeable,dependent: :destroy
  
  scope :top_rated, -> { order(rating: :desc, created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
  %w[rating created_at user_id book_id]
end

def self.ransackable_associations(auth_object = nil)
  %w[user book likes]
end

end

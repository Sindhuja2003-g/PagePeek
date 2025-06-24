class Book < ApplicationRecord
  has_and_belongs_to_many :genres
  has_many :reviews ,dependent: :destroy
  has_many :likes, as: :likeable,dependent: :destroy
  before_save :capitalize_title
  validates :title, presence: true
  validates :author, presence: true
  validates :published, presence: true
  has_many :wishlists, dependent: :destroy
  has_many :wishlisted_by, through: :wishlists, source: :user


  scope :most_liked, -> {
    left_joins(:likes)
    .group(:id)
    .order('COUNT(likes.id) DESC')
  }
  scope :search, ->(query) {
  where("title ILIKE :q OR author ILIKE :q", q: "%#{query}%")
}


  private

  def capitalize_title
    self.title = title.titleize
  end
end



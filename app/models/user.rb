class User < ApplicationRecord
  enum role: { user: 0, moderator: 1 }


  before_validation :set_default_role, on: :create

  has_one :profile, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reviewed_books, through: :reviews, source: :book

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  after_create :create_profile

  private

  def create_profile
    self.build_profile.save
  end

  def set_default_role
    self.role ||= :user
  end
end

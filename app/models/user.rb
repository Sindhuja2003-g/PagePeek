class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { user: 0, moderator: 1 }


  before_validation :set_default_role, on: :create
  validates :username, presence: true, uniqueness: true
  has_and_belongs_to_many :wishlist_books, class_name: 'Book', join_table: :wishlists


  has_one :profile, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reviewed_books, through: :reviews, source: :book

  has_many :liked_books, through: :likes, source: :likeable, source_type: 'Book'



  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  after_create :create_profile

def self.ransackable_attributes(auth_object = nil)
  %w[username email role created_at]
end

def self.ransackable_associations(auth_object = nil)
  %w[profile reviews likes reviewed_books liked_books]
end



  private

  def create_profile
    self.build_profile.save
  end

  def set_default_role
    self.role ||= :user
  end
end

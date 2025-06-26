require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'associations' do
    it 'can have many wishlist_books (Books)' do
      book = create(:book)
      user.wishlist_books << book
      expect(user.wishlist_books).to include(book)
    end

    it 'has one profile that is destroyed with the user' do
      user.save!
      profile = user.profile
      user.destroy
      expect(Profile.find_by(id: profile.id)).to be_nil
    end

    it 'can have many reviews that are destroyed with the user' do
      user.save!
      review = create(:review, user: user)
      expect(user.reviews).to include(review)
      user.destroy
      expect(Review.find_by(id: review.id)).to be_nil
    end

    it 'can have many likes that are destroyed with the user' do
      user.save!
      like = create(:like, user: user)
      expect(user.likes).to include(like)
      user.destroy
      expect(Like.find_by(id: like.id)).to be_nil
    end

    it 'can access reviewed_books through reviews' do
      book = create(:book)
      create(:review, user: user, book: book)
      user.save!
      expect(user.reviewed_books).to include(book)
    end

    it 'can access liked_books through likes (polymorphic)' do
      book = create(:book)
      like = create(:like, user: user, likeable: book)
      user.save!
      expect(user.liked_books).to include(book)
    end
  end

  describe 'validations' do
    it 'is invalid without username' do
      user.username = nil
      expect(user).not_to be_valid
    end

    it 'is invalid without email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'is invalid without password' do
      user.password = nil
      expect(user).not_to be_valid
    end

    it 'does not allow duplicate usernames (case insensitive)' do
      create(:user, username: 'johndoe')
      user.username = 'JohnDoe'
      expect(user).not_to be_valid
    end

    it 'does not allow duplicate emails (case insensitive)' do
      create(:user, email: 'test@example.com')
      user.email = 'TEST@example.com'
      expect(user).not_to be_valid
    end
  end

  describe 'enums' do
    it 'has a role enum with values user and moderator' do
      expect(User.roles.keys).to include('user', 'moderator')
    end
  end

  describe 'callbacks' do
    it 'downcases the username before validation' do
      user = build(:user, username: 'JohnDoe')
      user.valid?
      expect(user.username).to eq('johndoe')
    end

    it 'sets default role to user before validation' do
      new_user = User.new(username: 'tester', email: 'test@example.com', password: 'password123')
      new_user.valid?
      expect(new_user.role).to eq('user')
    end

    it 'creates profile after user is created' do
      user = create(:user)
      expect(user.profile).to be_present
    end
  end

end

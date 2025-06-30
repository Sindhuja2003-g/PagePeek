require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'associations' do
    let!(:book) { create(:book) }

    context 'wishlist_books' do
      before { user.wishlist_books << book }

      it 'includes the added book' do
        expect(user.wishlist_books).to include(book)
      end
    end

    context 'profile' do
      let!(:saved_user) { user.save! && user }

      it 'has a profile' do
        expect(saved_user.profile).to be_present
      end

      it 'destroys the profile when user is destroyed' do
        profile = saved_user.profile
        saved_user.destroy
        expect(Profile.find_by(id: profile.id)).to be_nil
      end
    end

    context 'reviews' do
      let!(:saved_user) { user.save! && user }
      let!(:review) { create(:review, user: saved_user) }

      it 'includes the created review' do
        expect(saved_user.reviews).to include(review)
      end

      it 'destroys reviews when user is destroyed' do
        saved_user.destroy
        expect(Review.find_by(id: review.id)).to be_nil
      end
    end

    context 'likes' do
      let!(:saved_user) { user.save! && user }
      let!(:like) { create(:like, user: saved_user) }

      it 'includes the created like' do
        expect(saved_user.likes).to include(like)
      end

      it 'destroys likes when user is destroyed' do
        saved_user.destroy
        expect(Like.find_by(id: like.id)).to be_nil
      end
    end

    context 'reviewed_books' do
      let!(:book) { create(:book) }
      let!(:saved_user) { user.save! && user }
      let!(:review) { create(:review, user: saved_user, book: book) }

      it 'includes books through reviews' do
        expect(saved_user.reviewed_books).to include(book)
      end
    end

    context 'liked_books' do
      let!(:book) { create(:book) }
      let!(:saved_user) { user.save! && user }
      let!(:like) { create(:like, user: saved_user, likeable: book) }

      it 'includes books through likes (polymorphic)' do
        expect(saved_user.liked_books).to include(book)
      end
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

    context 'uniqueness validations' do
      before { create(:user, username: 'johndoe', email: 'test@example.com') }

      it 'does not allow duplicate usernames (case insensitive)' do
        user.username = 'JohnDoe'
        expect(user).not_to be_valid
      end

      it 'does not allow duplicate emails (case insensitive)' do
        user.email = 'TEST@example.com'
        expect(user).not_to be_valid
      end
    end
  end

  describe 'enums' do
    it 'has a role enum with values user and moderator' do
      expect(User.roles.keys).to include('user')
    end

    it 'has a role enum with values user and moderator' do
      expect(User.roles.keys).to include('moderator')
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
      created_user = create(:user)
      expect(created_user.profile).to be_present
    end
  end
end

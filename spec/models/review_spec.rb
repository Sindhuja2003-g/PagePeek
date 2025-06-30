require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:review) { build(:review, user: user, book: book) }

  describe 'associations' do
    it 'belongs to user' do
      expect(review.user).to eq(user)
    end

    it 'belongs to book' do
      expect(review.book).to eq(book)
    end

    context 'likes' do
      before do
        review.save!
        @like = create(:like, likeable: review)
      end

      it 'includes likes' do
        expect(review.likes).to include(@like)
      end

      it 'destroys likes when review is destroyed' do
        review.destroy
        expect(Like.where(id: @like.id)).to be_empty
      end
    end
  end

  describe 'validations' do
    it 'is invalid without a rating' do
      review.rating = nil
      expect(review).not_to be_valid
    end

    it 'is invalid if rating is less than 1' do
      review.rating = 0
      expect(review).not_to be_valid
    end

    it 'is invalid if rating is greater than 5' do
      review.rating = 6
      expect(review).not_to be_valid
    end

    it 'is valid if rating is between 1 and 5' do
      review.rating = 3
      expect(review).to be_valid
    end
  end

  describe '.top_rated' do
    let!(:review1) { create(:review, rating: 5, created_at: 1.day.ago) }
    let!(:review2) { create(:review, rating: 4, created_at: 2.days.ago) }
    let!(:review3) { create(:review, rating: 5, created_at: 3.days.ago) }

    it 'orders reviews by rating desc, then by created_at desc' do
      expect(Review.top_rated).to eq([review1, review3, review2])
    end
  end
end

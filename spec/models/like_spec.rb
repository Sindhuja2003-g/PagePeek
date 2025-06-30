require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    let(:like) { create(:like, user: user) }

    it 'belongs to a user' do
      expect(like.user).to eq(user)
    end
  end

  describe 'polymorphic association' do
    context 'when likeable is a Book' do
      let(:book) { create(:book) }
      let(:like) { create(:like, likeable: book, user: user) }

      it 'belongs to the book' do
        expect(like.likeable).to eq(book)
      end
    end

    context 'when likeable is a Review' do
      let(:review) { create(:review) }
      let(:like) { create(:like, likeable: review, user: user) }

      it 'belongs to the review' do
        expect(like.likeable).to eq(review)
      end
    end
  end
end

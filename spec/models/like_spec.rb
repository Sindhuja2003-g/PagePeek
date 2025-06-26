require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }

 
  describe 'associations' do
    it 'belongs to a user' do
      like = create(:like, user: user)
      expect(like.user).to eq(user)
    end

    it 'belongs to a likeable polymorphic object' do
      book = create(:book)
      like = create(:like, likeable: book, user: user)
      expect(like.likeable).to eq(book)
    end
  end


  describe 'polymorphic association' do
    it 'can belong to a Book' do
      book = create(:book)
      like = create(:like, likeable: book, user: user)
      expect(like.likeable).to eq(book)
    end

    it 'can belong to a Review' do
      review = create(:review)
      like = create(:like, likeable: review, user: user)
      expect(like.likeable).to eq(review)
    end
  end


end

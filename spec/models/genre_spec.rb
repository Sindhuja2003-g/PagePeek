require 'rails_helper'

RSpec.describe Genre, type: :model do
  let(:genre) { create(:genre) }
  let(:book1) { create(:book) }
  let(:book2) { create(:book) }

  describe 'associations' do
    before do
      genre.books << [book1, book2]
    end

    it 'can be associated with the first book' do
      expect(genre.books).to include(book1)
    end

    it 'can be associated with the second book' do
      expect(genre.books).to include(book2)
    end

    it 'has exactly two books associated' do
      expect(genre.books.size).to eq(2)
    end
  end
end

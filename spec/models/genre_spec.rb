require 'rails_helper'

RSpec.describe Genre, type: :model do
  let(:genre) { build(:genre) }


  describe 'associations' do
    it 'can be associated with many books' do
      book1 = create(:book)
      book2 = create(:book)
      genre.books << [book1, book2]
      genre.save
      expect(genre.books).to match_array([book1, book2])
    end
  end


end

require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { build(:book) }

  describe 'associations' do
    let!(:genre1) { create(:genre) }
    let!(:genre2) { create(:genre) }
    let!(:user1)  { create(:user) }
    let!(:user2)  { create(:user) }

    before do
      book.genres << [genre1, genre2]
      book.wishlisted_by << [user1, user2]
      book.save
    end

    it 'can have many genres - includes genre1' do
      expect(book.genres).to include(genre1)
    end

    it 'can have many genres - includes genre2' do
      expect(book.genres).to include(genre2)
    end

    it 'can be wishlisted by many users - includes user1' do
      expect(book.wishlisted_by).to include(user1)
    end

    it 'can be wishlisted by many users - includes user2' do
      expect(book.wishlisted_by).to include(user2)
    end

    it 'can have many reviews which are destroyed on deletion' do
      book.save!
      create_list(:review, 2, book: book)
      expect { book.destroy }.to change { Review.count }.by(-2)
    end

    it 'can have many likes which are destroyed on deletion' do
      book.save!
      user = create(:user)
      create_list(:like, 2, likeable: book, user: user)
      expect { book.destroy }.to change { Like.count }.by(-2)
    end
  end

  describe 'validations' do
    it 'is invalid without a title' do
      book.title = nil
      expect(book).not_to be_valid
    end

    it 'is invalid without an author' do
      book.author = nil
      expect(book).not_to be_valid
    end

    it 'is invalid without a published date' do
      book.published = nil
      expect(book).not_to be_valid
    end
  end

  describe 'callbacks' do
    it 'capitalizes each word in the title before save' do
      book.title = 'the ruby way'
      book.save!
      expect(book.title).to eq('The Ruby Way')
    end
  end

describe '.most_liked' do
  before do
    @book1 = create(:book)
    @book2 = create(:book)
    @user = create(:user)
    create_list(:like, 3, likeable: @book1, user: @user)
    create(:like, likeable: @book2, user: @user)
  end

  it 'returns books ordered by number of likes descending' do
    result = Book.most_liked

    aggregate_failures 'checking order of most liked books' do
      expect(result.first).to eq(@book1)
      expect(result.second).to eq(@book2)
    end
  end
end


  describe '.search' do
    let!(:book1) { create(:book, title: 'Harry Potter', author: 'J.K. Rowling') }
    let!(:book2) { create(:book, title: 'Ruby Secrets', author: 'Yukihiro Matsumoto') }

    it 'returns books matching title' do
      expect(Book.search('potter')).to include(book1)
    end

    it 'returns books matching author' do
      expect(Book.search('ruby')).to include(book2)
    end

    it 'returns no books if no match is found' do
      expect(Book.search('java')).to be_empty
    end
  end
end

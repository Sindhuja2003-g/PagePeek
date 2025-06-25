class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wishlist_books = current_user.wishlist_books
  end

  def add
    book = Book.find(params[:book_id])
    current_user.wishlist_books << book unless current_user.wishlist_books.include?(book)
    redirect_back fallback_location: books_path, notice: "Book added to wishlist."
  end

  def remove
    book = Book.find(params[:book_id])
    current_user.wishlist_books.delete(book)
    redirect_back fallback_location: books_path, alert: "Book removed from wishlist."
  end
end

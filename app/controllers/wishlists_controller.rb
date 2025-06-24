class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wishlist_books = current_user.wishlist_books
  end

  def create
    book = Book.find(params[:book_id])
    current_user.wishlist_books << book unless current_user.wishlist_books.include?(book)
    redirect_back fallback_location: books_path, notice: "Book added to your wishlist."
  end

  def destroy
    wishlist = current_user.wishlists.find(params[:id])
    wishlist.destroy
    redirect_back fallback_location: wishlists_path, notice: "Book removed from your wishlist."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: wishlists_path, alert: "Wishlist entry not found."
  end
end

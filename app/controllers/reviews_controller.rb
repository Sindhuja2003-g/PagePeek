class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :authorize_review_action, only: [:update, :destroy]
  
  def create
    if user_signed_in? && current_user.moderator?
    redirect_to book_path(params[:book_id]), alert: "Moderators cannot write reviews."
    return
    end

    @book = Book.find(params[:book_id])
    @review = @book.reviews.new(review_params.merge(user: current_user))
    if @review.save
      redirect_to book_path(@book), notice: "Review added."
    else
      redirect_to book_path(@book), alert: "Could not add review."
    end
  end

  def destroy
    @review.destroy
    redirect_to book_path(@review.book), notice: "Review deleted."
  end


  def my_reviews
    @reviews = current_user.reviews.includes(:book)
  end

  def edit
    @review = Review.find(params[:id])
    @book = @review.book
  end

  def update
    @review = Review.find(params[:id])
    @book = @review.book

    if @review.update(review_params)
      redirect_to my_reviews_path, notice: "Review updated successfully!"
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def authorize_review_action
    unless @review.user == current_user || moderator?
      redirect_to book_path(@review.book), alert: "Access denied."
    end
  end

  def review_params
    params.require(:review).permit(:rating, :review)
  end


end

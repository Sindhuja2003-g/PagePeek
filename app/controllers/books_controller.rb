class BooksController < ApplicationController
  before_action :require_login
  before_action :require_moderator, only: [:new, :create, :edit, :update, :destroy]


  def index
    @genres = Genre.all
    @books = Book.all.includes(:likes, :reviews, :genres)
  end


  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews.includes(:user)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: "Book added."
    else
      render :new
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to @book, notice: "Book updated."
    else
      render :edit
    end
  end

  def destroy
    Book.find(params[:id]).destroy
    redirect_to books_path, notice: "Book deleted."
  end

  private
  def book_params
    params.require(:book).permit(:title, :author, :description, :published, genre_ids: [])
  end

end

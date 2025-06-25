module Api
  module V1
    class BooksController < ActionController::API
      before_action :doorkeeper_authorize!
      before_action :set_book, only: [:show, :update, :destroy]
      before_action :require_moderator!, only: [:create, :update, :destroy]
      
  def most_viewed
  books = Book.where("view_count > 0").order(view_count: :desc).limit(10)
  render json: books.as_json(only: [:id, :title, :author, :view_count])
end


      def index
        @books = Book.all
        render json: @books
      end

      def show
        render json: @book
      end

      def create
        @book = Book.new(book_params)
        if @book.save
          render json: @book, status: :created
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @book.update(book_params)
          render json: @book
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @book.destroy
        head :no_content
      end

      private

      def set_book
        @book = Book.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Book not found" }, status: :not_found
      end

      def book_params
        params.require(:book).permit(:title, :author, :description, :published, genre_ids: [])
      end

      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def require_moderator!
        unless current_user&.moderator?
          render json: { error: "Forbidden: Only moderators can perform this action." }, status: :forbidden
        end
      end

    end
  end
end

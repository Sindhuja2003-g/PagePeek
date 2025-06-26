module Api
  module V1
    class BooksController < ActionController::API
      before_action :doorkeeper_authorize!
      before_action :require_moderator!, only: [:create, :update, :destroy]
      before_action :set_book, only: [:show, :update, :destroy]


      def index
        @books = Book.all
        render 'api/v1/books/index'
      end

      def show
        render 'api/v1/books/show'
      end

      def most_viewed
        @books = Book.where("view_count > 0").order(view_count: :desc).limit(10)
        render 'api/v1/books/most_viewed'
      end

      def create
        @book = Book.new(book_params)
        if @book.save
          render 'api/v1/books/show', status: :created
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @book.update(book_params)
          render 'api/v1/books/show'
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
        render json: { error: "Forbidden: Only moderators can perform this action." }, status: :forbidden unless current_user&.moderator?
      end
    end
  end
end

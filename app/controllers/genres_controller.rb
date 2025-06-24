class GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :require_moderator, only: [:new, :create]

  def index
    @genres = Genre.all
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to genres_path, notice: "Genre created successfully."
    else
      render :new
    end
  end

  def show
    @genre = Genre.find(params[:id])
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end
end

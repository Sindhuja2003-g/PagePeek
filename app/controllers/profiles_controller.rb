class ProfilesController < ApplicationController
  before_action :authenticate_user!


  def edit
    @profile = current_user.profile
    @liked_books = current_user.liked_books
  end

  def show
  @user = User.find_by!(username: params[:id])
  @profile = @user.profile
  @reviews = @user.reviews.includes(:book)
  @liked_books = @user.liked_books
  end

  def update
    @profile = current_user.profile
    if @profile.update(profile_params)
      redirect_to books_path, notice: "Profile updated."
    else
      render :edit
    end
  end

  def destroy
    current_user.destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Account deleted."
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :bio,:location, :goodreads_url)
  end
end

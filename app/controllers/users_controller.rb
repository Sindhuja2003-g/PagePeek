class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = :user # force default role
    if @user.save
      session[:user_id] = @user.id
      redirect_to books_path, notice: "Signed up!"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.password == params[:password]
      session[:user_id] = user.id
      redirect_to books_path, notice: "Welcome back!"
    else
      flash.now[:alert] = "Invalid credentials"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out!"
    
  end
end

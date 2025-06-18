class ProfilesController < ApplicationController
  before_action :require_login

  def edit
    @profile = current_user.profile
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
    params.require(:profile).permit(:name, :bio)
  end
end

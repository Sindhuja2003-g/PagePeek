class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :moderator?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def moderator?
    current_user&.moderator?
  end

  def require_login
    unless logged_in?
      session[:user_id] = nil 
      redirect_to login_path, alert: "Please log in again"
    end
  end

  def require_moderator
    redirect_to root_path, alert: "Access denied" unless moderator?
  end
end

class ApplicationController < ActionController::Base

  before_action :authenticate_user_unless_active_admin

   helper_method :moderator?

  before_action :configure_permitted_parameters, if: :devise_controller?


  def moderator?
    current_user&.moderator?
  end

  def require_moderator
    redirect_to root_path, alert: "Access denied" unless moderator?
  end

  private

  def authenticate_user_unless_active_admin
    unless active_admin_request?
      authenticate_user!
    end
  end

  def active_admin_request?
    request.fullpath.starts_with?('/admin')
  end 

 
  
 
protected

def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
end

end

class ApplicationController < ActionController::Base

  before_action :authenticate_user!  

  helper_method :moderator?

  before_action :configure_permitted_parameters, if: :devise_controller?


  def moderator?
    current_user&.moderator?
  end

  def require_moderator
    redirect_to root_path, alert: "Access denied" unless moderator?
  end
  
 
protected

def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
end

end

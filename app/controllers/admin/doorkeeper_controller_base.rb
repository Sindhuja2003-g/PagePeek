module Admin
  class DoorkeeperControllerBase < ActionController::Base
    before_action :authenticate_admin_user!
  end
end

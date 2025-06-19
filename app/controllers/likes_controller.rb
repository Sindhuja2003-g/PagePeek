class LikesController < ApplicationController
  before_action :require_login

  def create
    likeable = find_likeable
    likeable.likes.create(user: current_user) unless likeable.likes.exists?(user: current_user)
    redirect_back fallback_location: root_path
  end

  def destroy
    likeable = find_likeable
    like = likeable.likes.find_by(user: current_user)
    like.destroy if like
    redirect_back fallback_location: root_path
  end

  private

  def find_likeable
    params[:likeable_type].constantize.find(params[:likeable_id])
  end
end

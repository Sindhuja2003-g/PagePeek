class LikesController < ApplicationController
  before_action :require_login

  def create
    likeable = find_likeable
    unless likeable.likes.exists?(user: current_user)
      likeable.likes.create(user: current_user)
      likeable.increment!(:like_count)
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    likeable = find_likeable
    like = likeable.likes.find_by(user: current_user)
    if like
      like.destroy
      likeable.decrement!(:like_count)
    end
    redirect_back fallback_location: root_path
  end

  private

  def find_likeable
    params[:likeable_type].constantize.find(params[:likeable_id])
  end
end

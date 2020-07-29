class StaticPagesController < ApplicationController
  def home
  	if user_signed_in?
	  following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
  	  @posts = Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: current_user.id).order(created_at: :desc)
  	  @habits = Habit.where(user_id: current_user.id)
  	end
  end

  def help
  end
end

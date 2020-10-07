class UsersController < ApplicationController
  
  def show
  	@user = User.find(params[:id])
  	@habits = @user.habits
  	@posts = @user.posts.order(created_at: :desc)
  end

  def following
  	@title = "フォロー"
  	@user = User.find(params[:user_id])
  	@users = @user.following
    @habits = Habit.where(user_id: current_user.id)
  	render "show_follow"
  end

  def followers
  	@title = "フォロワー"
  	@user = User.find(params[:user_id])
  	@users = @user.followers
    @habits = Habit.where(user_id: current_user.id)
  	render "show_follow"
  end
end

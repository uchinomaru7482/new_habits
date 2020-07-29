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
  	render "show_follow"
  end

  def followers
  	@title = "フォロワー"
  	@user = User.find(params[:user_id])
  	@users = @user.followers
  	render "show_follow"
  end
end

class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  	@habits = @user.habits
  	@posts = @user.posts
  end
end

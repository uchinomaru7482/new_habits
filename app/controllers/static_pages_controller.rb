class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
      @posts = Post.where("user_id IN (#{following_ids}) OR user_id = :user_id",
                          user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(15)
      @habits = Habit.where(user_id: current_user.id)
    else
      redirect_to "/lp"
    end
  end

  def lp
    if user_signed_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def help
    @habits = Habit.where(user_id: current_user.id)
  end
end

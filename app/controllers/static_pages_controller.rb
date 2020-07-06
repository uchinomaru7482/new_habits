class StaticPagesController < ApplicationController
  def home
  	if user_signed_in?
  	  @habits = Habit.where(user_id: current_user.id)
  	  @posts = Post.where(user_id: current_user.id)
  	end
  end

  def help
  end
end

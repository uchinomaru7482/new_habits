class StaticPagesController < ApplicationController
  def home
  	@habits = Habit.where(user_id: current_user.id) if user_signed_in?
  end

  def help
  end
end

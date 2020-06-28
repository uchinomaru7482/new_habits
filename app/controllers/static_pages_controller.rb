class StaticPagesController < ApplicationController
  def home
  	@habits = Habit.where(user_id: current_user.id)
  end

  def help
  end
end

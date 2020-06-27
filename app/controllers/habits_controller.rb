class HabitsController < ApplicationController
  def new
  	@habit = Habit.new
  end

  def create
  	@habit = Habit.find(params[:id])
  	if @habit.save
  		flash[:success] = "習慣を登録しました"
  		redirect_to "/"
  	else
  		render "new"
  	end
  end


  private 
  def habit_params
  	params.require(:habit).permit(:user_id, :habit_content, :habit_type, :total_days, :total_time, :continuation_days, :open_range)
  end
end

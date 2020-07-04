class HabitsController < ApplicationController
  
  INIT_VALUE = 0

  def new
    @habit = Habit.new
  end

  def create
    @habit = Habit.new(habit_params)
    @habit.user_id = current_user.id
    @habit.total_days = INIT_VALUE
    @habit.total_time = INIT_VALUE
    @habit.continuation_days = INIT_VALUE
  	if @habit.save
  	  flash[:success] = "習慣を登録しました"
  	  redirect_to "/"
    else
  	  render "new"
    end
  end

  def edit
    @habit = Habit.find(params[:id])
  end

  def update
    @habit = Habit.find(params[:id])
    if @habit.update(habit_params)
      redirect_to "/"
    else
      render "edit"
    end
  end

  def destroy
    Habit.find(params[:id]).destroy
    redirect_to "/"
  end


  private 
  def habit_params
    params.require(:habit).permit(:user_id, :habit_content, :habit_type, :open_range)
  end
end

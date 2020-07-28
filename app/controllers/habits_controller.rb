class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:update, :destroy]
  
  INIT_VALUE = 0

  def new
    @habit = Habit.new
  end

  def create
  	@habit = current_user.habits.build(habit_params)
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
    redirect_to "/users/#{current_user.id}"
  end

  private 
  def habit_params
    params.require(:habit).permit(:user_id, :content, :record_type, :open_range)
  end

  def correct_user
  	@habit = current_user.habits.find_by(id: params[:id])
  	redirect_to "/" if @habit.nil?
  end
end
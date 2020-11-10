class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:show, :update, :destroy]

  def new
    @habit = Habit.new
  end

  def create
    @habit = current_user.habits.build(habit_params)
    if @habit.save
      flash[:success] = "習慣を登録しました"
      redirect_to root_path
    else
      render "new"
    end
  end

  def show
    @habit = Habit.find(params[:id])
    @achievements = Achievement.where(habit_id: @habit.id)
    @posts = @habit.posts.page(params[:page]).per(10)
  end

  def edit
    @habit = Habit.find(params[:id])
  end

  def update
    @habit = Habit.find(params[:id])
    if @habit.update(habit_params)
      redirect_to root_path
    else
      render "edit"
    end
  end

  def destroy
    Habit.find(params[:id]).destroy
    redirect_to "/users/#{current_user.id}"
  end

  def search
    @search_habits = if params[:habit_name].present?
                       Habit.where("content LIKE ?", "%#{params[:habit_name]}%")
                     else
                       Habit.none
                     end
  end

  private

  def habit_params
    params.require(:habit).permit(:user_id, :content, :record_type, :open_range)
  end

  def correct_user
    @habit = current_user.habits.find_by(id: params[:id])
    redirect_to root_path if @habit.nil?
  end
end

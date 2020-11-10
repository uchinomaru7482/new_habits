class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: :destroy

  @today = Date.current.all_day

  def new
    @habit = Habit.find(params[:habit_id])
    @habits = Habit.where(user_id: current_user.id)
    @post = Post.new
    @achievement = @habit.achievements.find_by(created_at: @today)
  end

  def create
    @habit = Habit.find(params[:habit_id])
    @post = @habit.posts.build(post_params)
    @post.user_id = current_user.id
    if @post.save
      save_achievement
      @habit.calculation_management_value
      redirect_to root_path
    else
      @habits = Habit.where(user_id: current_user.id)
      @achievement = @habit.achievements.find_by(created_at: @today)
      render "new"
    end
  end

  def show
    @habits = Habit.where(user_id: current_user.id)
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to "/users/#{current_user.id}"
  end

  private

  def post_params
    params.require(:post).permit(:content, :image)
  end

  def achievement_params
    params.require(:post).permit(:report, :check)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_path if @post.nil?
  end

  def save_achievement
    if Achievement.already_save_achievement_today?(@habit)
      @achievement = @habit.achievements.build(achievement_params)
    else
      @achievement = @habit.achievements.find_by(created_at: @today)
      @achievement.check = params[:post][:check] if @achievement.check == false
      @achievement.report += params[:post][:report].to_i if @habit.record_type == Habit::REPORT_TYPE
    end
    @achievement.save
  end
end

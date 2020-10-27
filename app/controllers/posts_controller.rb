class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: :destroy

  def new
    @habit = Habit.find(params[:habit_id])
    @habits = Habit.where(user_id: current_user.id)
    @post = Post.new
    @today = Date.current.all_day
    @achievement = @habit.achievements.find_by(created_at: @today)
  end

  def create
    @habit = Habit.find(params[:habit_id])
    @post = @habit.posts.build(post_params)
    @post.user_id = @habit.user_id
    if @post.user_id == current_user.id && @post.save
      save_achievement
      @habit.total_days = @habit.count_total_days if params[:post][:check] == "true"
      @habit.continuation_days = @habit.count_continuation_days if params[:post][:check] == "true"
      @habit.total_time = @habit.count_total_time if @habit.record_type == false
      @habit.save
      redirect_to "/"
    else
      @habits = Habit.where(user_id: current_user.id)
      @today = Date.current.all_day
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
    parameter = if @habit.record_type == false
                  [:report, :check]
                else
                  [:check]
                end
    params.require(:post).permit(parameter)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to "/" if @post.nil?
  end

  def save_achievement
    if Achievement.already_save_achievement_today?(@habit)
      @achievement = @habit.achievements.build(achievement_params)
    else
      @today = Date.current.all_day
      @achievement = @habit.achievements.find_by(created_at: @today)
      @achievement.check = params[:post][:check] if @achievement.check == false && params[:post][:check] == "true"
      @achievement.report += params[:post][:report].to_i if @habit.record_type == false
    end
    @achievement.save
  end
end

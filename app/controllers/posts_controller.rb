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

  def destroy
  	Post.find(params[:id]).destroy
  	redirect_to "/users/#{current_user.id}"
  end

  private

  def post_params
  	params.require(:post).permit(:content, :image, :execution_time)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
  	redirect_to "/" if @post.nil?
  end

  def already_save_achievement_today?
    @today = Date.current.all_day
    @achievement = @habit.achievements.find_by(created_at: @today)
    @achievement.nil?
  end

  def save_achievement
    if already_save_achievement_today?
      @achievement = @habit.achievements.build
      @achievement.check = params[:post][:check]
      @achievement.report = params[:post][:time].to_i if @habit.record_type == false
    else
      @today = Date.current.all_day
      @achievement = @habit.achievements.find_by(created_at: @today)
      if @achievement.check == false && params[:post][:check] == "true"
        @achievement.check = params[:post][:check]
      end
      @achievement.report += params[:post][:time].to_i if @habit.record_type == false
    end
    @achievement.save
  end
end

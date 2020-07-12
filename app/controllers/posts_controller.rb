class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: :destroy

  def new
  	@habit = Habit.find(params[:habit_id])
  	@post = Post.new
  end

  def create
  	@habit = Habit.find(params[:habit_id])
  	@post = @habit.posts.build(post_params)
  	@post.user_id = @habit.user_id
  	if @post.user_id == current_user.id && @post.save
      save_achievement
      count_days
      redirect_to "/"
  	else
  	  render "new"
  	end
  end

  def destroy
  	Post.find(params[:id]).destroy
  	redirect_to "/users/#{current_user.id}"
  end

  private
  def post_params
  	params.require(:post).permit(:content, :execution_time)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
  	redirect_to "/" if @post.nil?
  end

  #習慣を今日行ったかどうかを保存
  def save_achievement
    if params[:post][:check] == "true" && already_save_achievement?
      @achievement = @habit.achievements.build
      @achievement.check = true
      @achievement.save
    end
  end

  def already_save_achievement?
    @today = Date.current.all_day
    @achievement = @habit.achievements.find_by(created_at: @today)
    @achievement.nil?
  end

  def count_days
    @count_value = @habit.achievements.count
    @habit.total_days = @count_value

    @yesterday = (Date.current - 1).all_day
    if @habit.achievements.find_by(created_at: @yesterday)
      @habit.continuation_days += 1
    else
      @habit.continuation_days = 1 if params[:post][:check] == "true"
    end
    @habit.save
  end
end

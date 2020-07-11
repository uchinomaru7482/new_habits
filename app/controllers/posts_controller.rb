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
    if params[:post][:check] == "true"
      @achievement = Achievement.new
      @achievement.habit_id = params[:habit_id]
      @achievement.check = true
      @achievement.save
    end
  end

  def count_days
    
  end
end

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
  	  redirect_to "/"
  	else
  	  render "new"
  	end
  end

  def destroy
  	Post.find(params[:id]).destroy
  	redirect_to "/"
  end

  private
  def post_params
  	params.require(:post).permit(:content, :execution_time)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
  	redirect_to "/" if @post.nil?
  end
end

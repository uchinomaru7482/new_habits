class Posts::LikesController < ApplicationController
  def create
    @like = Like.new(user_id: current_user.id, post_id: params[:post_id])
    @like.save
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, post_id: params[:post_id])
    @like.destroy
  end
end

module PostsHelper
  def already_liked?(post)
    Like.find_by(user_id: current_user.id, post_id: post.id)
  end
end

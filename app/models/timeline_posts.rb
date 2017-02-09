class TimelinePosts
  def initialize(user:)
    @user = user
  end

  def posts
    friend_ids = @user.friends.pluck(:id)
    
    Post.where(user_id: friend_ids, visibility: 0).or(Post.where(user_id: @user.id)).includes(:user, :post_images)
  end
end
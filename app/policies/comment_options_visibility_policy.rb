class CommentOptionsVisibilityPolicy
  def initialize(user:, comment:)
    @user = user
    @comment = comment
  end

  def visible?
    !@comment.deleted? && (@comment.user.id == @user.id || @comment.post_user == @user)
  end
end
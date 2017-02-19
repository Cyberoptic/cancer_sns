class CommentVisibilityPolicy
  def initialize(comment:, current_user:)
    @comment = comment
    @current_user = current_user
  end

  def visible?
    @comment.visible || @comment.user == @current_user || @comment.post_user == @current_user
  end
end
class CommentVisibilityTogglesController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.find(params[:comment_id])

    @comment.toggle_visibility!
  end
end

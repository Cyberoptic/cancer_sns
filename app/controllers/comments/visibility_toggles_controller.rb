class Comments::VisibilityTogglesController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.find(params[:comment_id])

    @comment.toggle_visibility!
    @comment.reload
  end
end

class Comments::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.find(params[:comment_id])
    current_user.like(@comment)

    @comment.reload

    respond_to do |format|
      format.js { render 'comments/emotion' }
    end
  end
end

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner

  def update
    @comment = find_comment
    @comment.update(comment_params)
  end

  def destroy
    @comment = find_comment
    
    @comment.delete!
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def find_comment
    @comment ||= Comment.find(params[:id])
  end

  def ensure_owner
    @comment = find_comment
    return if @comment.user == current_user
    format.json { render json: :unauthorized }
  end

end

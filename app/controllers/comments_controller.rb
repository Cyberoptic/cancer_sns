class CommentsController < ApplicationController
  before_action :authenticate_user!

  def update
    @comment = Comment.find(params[:id])

    @comment.update(comment_params)
  end

  def destroy
    @comment = Comment.find(params[:id])
    
    @comment.delete!
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

end

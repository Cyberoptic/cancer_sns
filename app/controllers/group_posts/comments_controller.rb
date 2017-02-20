class GroupPosts::CommentsController < ApplicationController
  def create    
    @post = GroupPost.find(params[:group_post_id]) 
    @comment = @post.comments.create(comment_params)
    respond_to do |format|
      if @comment.save
        format.js {}
      else
        format.js { render js: :no_head }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id)
  end
end

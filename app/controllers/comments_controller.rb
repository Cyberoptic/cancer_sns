class CommentsController < ApplicationController

def create
  @post = Post.includes(:comments,:user).find(params[:post_id])
  @comment = @post.comments.create(comment_params.merge(user_id: current_user.id))
  respond_to do |format|
    format.html {}
    format.js {}
  end  
end

private 

def comment_params
  params.require(:comment).permit(:text, :post_id)
end

end

class Posts::CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)

    respond_to do |format|
      if @comment.save
        if params[:post_images]
          params[:post_images]['photo'].each do |photo|
            @comment.post_images.create!(photo: photo, user_id: current_user.id)
          end
        end
        format.js {}
      else
        format.js { render js: :no_head }
      end
    end

  end

  private

  def comment_params
    params.require(:comment).permit(:text, :photo).merge(user_id: current_user.id)
  end
end

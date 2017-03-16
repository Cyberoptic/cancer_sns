class Comments::EmotionsController < ApplicationController
  def index
    @post = Comment.find(params[:comment_id])

    @emotions = @post.emotions.order(created_at: :desc)

    respond_to do |format|
      format.json {}
    end
  end
end

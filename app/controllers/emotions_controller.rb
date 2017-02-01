class EmotionsController < ApplicationController
  def index
    @post = Post.find(params[:post_id])

    @emotions = @post.emotions.order(created_at: :desc).decorate

    respond_to do |format|
      format.json {}
    end
  end
end

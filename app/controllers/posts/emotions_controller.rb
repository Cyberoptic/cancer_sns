class Posts::EmotionsController < ApplicationController
  def index
    @post = Post.find(params[:post_id])

    @emotions = @post.emotions.order(created_at: :desc)

    respond_to do |format|
      format.json {}
    end
  end
end

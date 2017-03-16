class GroupPosts::EmotionsController < ApplicationController
  def index
    @post = GroupPost.find(params[:group_post_id])

    @emotions = @post.emotions.order(created_at: :desc)

    respond_to do |format|
      format.json {}
    end
  end
end

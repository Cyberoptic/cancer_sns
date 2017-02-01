class GroupPosts::UnlikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = GroupPost.find(params[:group_post_id])
    current_user.unlike(@post)

    @post.reload

    respond_to do |format|
      format.js { render '/posts/emotions/destroy' }
    end
  end
end

class GroupPosts::SadsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = GroupPost.find(params[:group_post_id])    
    current_user.sad(@post)

    @post.reload

    respond_to do |format|      
      format.js { render '/posts/emotions/create' }
    end   
  end
end

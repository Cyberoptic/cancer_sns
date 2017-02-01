class Posts::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)    

    @post.reload

    respond_to do |format|
      format.js { render '/posts/emotions/create' }
    end   
  end
end

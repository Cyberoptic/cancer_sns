class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    # Like.create({user_id: current_user.id, post_id: @post.id})
    current_user.like(@post)
    # @like = Like.where(user_id: current_user.id, post_id: @post.id)
    respond_to do |format|
      format.html { redirect_to root_path}
      format.js {}
    end   
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.unlike(@post)
    
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js {}
    end
  end

end

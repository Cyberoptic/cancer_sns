class HappiesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    # Happy.create({user_id: current_user.id, post_id: @post.id})
    current_user.plus_happy(@post)

    respond_to do |format|
      format.html { redirect_to root_path}
      format.js {}
    end   
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.minus_happy(@post)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js {}
    end
  end
end

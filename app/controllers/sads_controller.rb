class SadsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    # Sad.create({user_id: current_user.id, post_id: @post.id})
    current_user.plus_sad(@post)

    respond_to do |format|
      format.html { redirect_to root_path}
      format.js {}
    end   
  end

  def destroy
    @post = Post.find(params[:id])
    current_user.minus_sad(@post)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js {}
    end
  end
end


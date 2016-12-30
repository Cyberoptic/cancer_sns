class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)    

    @post.reload

    respond_to do |format|
      format.html { redirect_to root_path}
      format.js {}
    end   
  end

  def destroy
    @post = Post.find(params[:id])
    current_user.unlike(@post)

    @post.reload

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js {}
    end
  end

end

class SadsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])    
    current_user.sad(@post)

    @post.reload

    respond_to do |format|
      format.html { redirect_to root_path}
      format.js {}
    end   
  end

end


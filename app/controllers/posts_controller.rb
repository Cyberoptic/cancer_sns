class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.newest_first
  end

  def show
    @post = Post.find(params[:id])
    @post_attachments = @post.post_attachments.all   
  end

  def new
    @post = Post.new
    @post_image = @post.post_images.build
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        params[:post_images]['photo'].each do |a|
          @post_image = @post.post_images.create!(:photo => a)
        end
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :content, post_images_attributes: [:id, :user_id, :post_id, :photo])
  end
end

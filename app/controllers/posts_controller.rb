class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.newest_first
  end

  def show
    @post = Post.find(params[:id])
    @post_attachments = @post.post_images.all   
  end

  def new
    @post = Post.new
    @post_image = @post.post_images.build
  end

  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        params[:post_images]['photo'].each do |a|
          binding.pry
          @post_image = @post.post_images.create!(photo: a, user_id: current_user.id)
        end
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, post_images_attributes: [:photo])
  end
end

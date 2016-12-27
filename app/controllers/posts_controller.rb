class PostsController < ApplicationController
  before_action :verify_owner, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @posts = Post.newest_first
  end

  def show
    @post = Post.find(params[:id])
    @post_images = @post.post_images.all   
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
          # binding.pry
          @post_image = @post.post_images.create!(photo: a, user_id: current_user.id)
        end
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    # if @post.update!(post_params)
    # # if @post.valid?
    #   redirect_to posts_path # configure apt routes
    # else
    #   render :new, status: :unprocessable_entity
    # end
    update_attachments if params[:post_images]
    if @post.update!(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

    def post_params
      params.require(:post).permit(:content, post_images_attributes: [:photo])
    end

    def verify_owner
      redirect_to posts_path if Post.find(params[:id]).user != current_user
    end
    
    def update_attachments
      @post = Post.find(params[:id])
      @post.post_images.each(&:destroy) if @post.post_images.present?
      params[:post_images]['photo'].each do |photo|
        # binding.pry
        @post_image = @post.post_images.create!(photo: photo, user_id: current_user.id)
      end
    end

end

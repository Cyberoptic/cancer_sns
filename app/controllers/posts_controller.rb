class PostsController < ApplicationController
  before_action :verify_owner, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @posts = Post.includes(:user, :post_images).visible_to_everyone.paginate(page: params[:page], per_page: 5).decorate
    @post = Post.new
    @post_images = @post.post_images.build
    respond_to do |format|
      format.html
      format.js
    end
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
        if params[:post_images]
          params[:post_images]['photo'].each do |a|
            @post_image = @post.post_images.create!(photo: a, user_id: current_user.id)
          end
        end
        format.html { redirect_to root_path }
      else
        format.html { render action: 'new' }
      end
    end
  end
  
  def update
    @post = Post.find(params[:id])
    update_attachments if params[:post_images]
    if @post.update(post_params)
      redirect_to :back, notice: '投稿が更新されました。'
    else
      redirect_to :back, alert: @post.errors.full_messages[0]
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  def more_comments
    @post = Post.find(params[:id])
    @comments = @post.comments.paginate(page: params[:page], per_page: 5).includes(:user).decorate
    respond_to do |format|
      format.js 
    end
  end

  private

    def post_params
      params.require(:post).permit(:content, :visibility, post_images_attributes: [:photo])
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

class GroupPostsController < ApplicationController
  before_action :verify_owner, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @posts = GroupPost.includes(:user, :post_images).paginate(page: params[:page], per_page: 5).decorate
    @post = GroupPost.new
    @post_images = @post.post_images.build
  end

  def show
    @post = GroupPost.find(params[:id])
    @post_images = @post.post_images.all   
  end

  def new
    @post = GroupPost.new
    @post_image = @post.post_images.build
  end

  def create
    @post = current_user.group_posts.new(group_post_params.merge(group_id: params[:group_id]))

    respond_to do |format|
      if @post.save!
        if params[:post_images]
          params[:post_images]['photo'].each do |a|
            @post_image = @post.post_images.create!(photo: a, user_id: current_user.id)
          end
        end
        format.html { redirect_to group_path(params[:group_id]) }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update    
    @post = GroupPost.find(params[:id])
    update_attachments if params[:post_images]
    @post.update(group_post_params)    
  end

  def destroy
    @post = GroupPost.find(params[:id])
    @post.destroy    
  end

  private

    def group_post_params
      params.require(:group_post).permit(:content, post_images_attributes: [:photo])
    end

    def verify_owner
      redirect_to group_posts_path if GroupPost.find(params[:id]).user != current_user
    end
    
    def update_attachments
      @post = GroupPost.find(params[:id])
      @post.post_images.each(&:destroy) if @post.post_images.present?
      params[:post_images]['photo'].each do |photo|
        @post_image = @post.post_images.create!(photo: photo, user_id: current_user.id)
      end
    end

end

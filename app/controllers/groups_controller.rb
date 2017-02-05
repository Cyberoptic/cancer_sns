class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @my_groups = current_user.groups

    if params[:group_search] && params[:group_search][:keyword]   
    
      @groups = Group.search(params[:group_search][:keyword])
    end

    @group_search = GroupSearch.new(params[:group_search])
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.group_posts.includes(:user, :post_images).paginate(page: params[:page], per_page: 5).decorate
    @post = GroupPost.new
    @post_images = @post.post_images.build

    mark_posts_as_read
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      current_user.group_memberships.create(group_id: @group.id)
      flash[:success] = "グループが作成されました。"
      redirect_to group_path(@group)
    else
      flash[:alert] = @group.errors.full_messages[0]
      render :new
    end
  end  

  private

  def mark_posts_as_read
    @group.group_posts.mark_as_read! :all, for: current_user
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end

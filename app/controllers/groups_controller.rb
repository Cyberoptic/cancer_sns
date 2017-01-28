class GroupsController < ApplicationController
  before_action :authenticate_user!

  def show
    @group = Group.find(params[:id])
    @post = GroupPost.new
    @post_images = @post.post_images.build
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

  def group_params
    params.require(:group).permit(:name, :description)
  end
end

class GroupInvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_member

  def index
    @group = find_group

    @invitations = @group.group_memberships.invited
  end

  def new
    @group = find_group
    @invitation = @group.group_memberships.new
  end

  def create
    @group = find_group

    @invitation = @group.group_memberships.new(group_memberships_params.merge(status: :invited))
    
    respond_to do |format|
      if @invitation.save
        user = User.find(group_memberships_params[:user_id])
        flash[:success] = "#{user.decorate.display_name}を招待しました。"
        format.js { render 'shared/flash_message' }
        format.html { redirect_to group_path(@group) }
      else
        flash[:alert] = @invitation.errors.full_messages[0]
        format.js { render 'shared/flash_message' }
        format.html { redirect_to group_path(@group) }
      end
    end
  end

  private

  def group_memberships_params
    params.require(:group_membership).permit(:user_id)
  end

  def find_group
    @group ||= Group.find(params[:group_id])
  end

  def ensure_member
    @group = find_group
    return if @group.group_memberships.find_by(user: current_user)
    flash[:alert] = "あなたはこのグループのメンバーではありません。"
    redirect_to group_path(@group)
  end
end

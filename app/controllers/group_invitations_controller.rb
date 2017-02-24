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

    @invitation = @group.group_memberships.new(group_memberships_params)

    respond_to do |format|
      if @invitation.save        
        format.js {}
        format.html { redirect_to group_path(@group) }
      else
        format.js {}
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

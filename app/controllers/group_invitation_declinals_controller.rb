class GroupInvitationDeclinalsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner_of_group_membership

  def create
    @group_membership = find_group_membership
    @id = @group_membership.id
    @group_membership.destroy

    respond_to do |format|
      format.js {}
      format.html {redirect_to root_path}
    end
  end

  private

  def find_group_membership
    @group_membership ||= GroupMembership.find(params[:group_invitation_id])
  end

  def ensure_owner_of_group_membership
    @group_membership = find_group_membership
    
    return if @group_membership.user == current_user
    flash[:alert] = "招待された方以外からの許可はできません。"
    redirect_to root_path
  end
end

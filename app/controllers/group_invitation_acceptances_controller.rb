class GroupInvitationAcceptancesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner_of_group_membership

  def create
    @group_membership = find_group_membership

    respond_to do |format|
      if @group_membership.update(status: :accepted)
        flash[:success] = "#{@group_membership.group.name}に参加しました。"
        format.js {}
        format.html { redirect_to group_path(@group_membership.group) }
      else
        flash[:alert] = @group_membership.errors.full_messages[0]
        format.js {}
        format.html { redirect_to group_path(@group_membership.group) }
      end
    end
  end

  private

  def find_group_membership
    @group_membership ||= GroupMembership.find(params[:id])
  end

  def ensure_owner_of_group_membership
    @group_membership = find_group_membership
    
    return if @group_membership == current_user
    flash[:alert] = "招待された方以外からの許可はできません。"
    redirect_to root_path
  end
end

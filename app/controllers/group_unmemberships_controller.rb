class GroupUnmembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_group_membership!

  def create 
    @group_membership.destroy

    respond_to do |format|
      format.js {}
    end   
  end

  private

  def ensure_group_membership!
    group = Group.find(params[:group_id])
    @group_membership = GroupMembership.find_by(user_id: current_user.id, group_id: group.id)
    return if @group_membership.present?
    flash[:alert] = "You must be a member to leave the group!"
    redirect_to group
  end

end

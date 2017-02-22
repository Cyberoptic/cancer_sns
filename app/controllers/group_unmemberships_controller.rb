class GroupUnmembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_group_membership!
  before_action :ensure_non_owner

  def create
    @id = @group_membership.id
    @group_membership.destroy

    respond_to do |format|
      format.js {}
      format.html { redirect_to group_path(@group) }
    end   
  end

  private

  def ensure_non_owner
    @group_membership = find_group_membership
    @group = find_group
    return unless @group_membership.user == @group.owner
    flash[:alert] = "グループのオーナーをメンバーから外すことはできません。"
    redirect_to group_path(@group)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_group_membership
    user_id = params[:user_id] || current_user.id
    @group_membership ||= GroupMembership.find_by(user_id: user_id, group_id: @group.id)
  end

  def ensure_group_membership!    
    @group = find_group

    @group_membership = find_group_membership
    return if @group_membership.present?
    flash[:alert] = "You must be a member to leave the group!"
    redirect_to @group
  end

end

class GroupInvitationAcceptancesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner_of_group_membership

  def create
    @group_membership = find_group_membership
    @group = @group_membership.group

    respond_to do |format|
      if @group_membership.update!(status: :accepted)
        flash[:success] = "#{@group.name}に参加しました。"
        format.js {}
        format.html { redirect_to group_path(@group) }
      else
        flash[:alert] = @group_membership.errors.full_messages[0]
        format.js {}
        format.html { redirect_to group_path(@group) }
      end
    end
  end

  private

  def create_notifications
    @group.moderators.each do |moderator|
      Notification.create({recipient: moderator, actor: @group_membership.user, action: "#{@group.name}に参加", notifiable: @group}) unless (moderator == current_user)
    end

    Notification.create({recipient: @group.owner, actor: @group_membership.user, action: "#{@group.name}に参加", notifiable: @group}) unless (@group.owner == current_user)
  end

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

class GroupMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_moderator!, only: :update

  def index
    @group = find_group
    @group_memberships = @group.group_memberships.order(created_at: :desc).includes(:user)
    @current_user_membership = @group_memberships.find_by_user_id(current_user.id)

    @unread_messages = Message.unread_by(current_user).includes(chat_room: [:user, :member, :messages])
    @unread_group_posts =  GroupPost.unread_by(current_user).includes(:user, :group)
  end

  def create
    @group = find_group
    current_user.group_memberships.create(group_id: params[:group_id])
    
    respond_to do |format|
      format.js {}
    end
  end

  def update
    @group_membership = find_group_membership

    @group_membership.update(group_membership_params)

    respond_to do |format|
      format.js {}
    end
  end

  private

  def find_group
    @group ||= Group.find(params[:group_id])
  end

  def find_group_membership
    @group_membership ||= GroupMembership.find(params[:id])
  end

  def ensure_moderator!
    @group_membership = find_group_membership
    group = @group_membership.group
    current_user_group_membership = current_user.group_memberships.find_by(group: group)
    return if current_user_group_membership.moderator?
    flash[:alert] = "グループ管理者以外編集できません。"
    redirect_to group_path(group)
  end

  def group_membership_params
    params.require(:group_membership).permit(:role)
  end
end
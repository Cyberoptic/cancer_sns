class GroupMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_moderator!, only: :update
  before_action :check_existing_membership, only: :create

  def index
    @group = find_group
    @group_memberships = @group.accepted_group_memberships.order(created_at: :desc).includes(:user).paginate(page: params[:page], per_page: 50)
    @current_user_membership = @group_memberships.find_by_user_id(current_user.id)
  end

  def create
    @group = find_group
    status = @group.accessible_to_everyone? ? "accepted" : "pending"

    @group_membership = current_user.group_memberships.create(group_id: params[:group_id], status: status)    

    respond_to do |format|
      if @group_membership.valid? && @group_membership.accepted?
        create_notifications
        flash[:success] = "#{@group.name}に参加しました。"
        format.js {}
        format.html { redirect_to group_path(@group) }
      else
        flash[:alert] = @group.errors.full_messages[0]
        format.js {}
        format.html { redirect_to groups_path }
      end
        
    end
  end

  def update
    @group_membership = find_group_membership

    @group_membership.update(group_membership_params)
    @group = @group_membership.group

    create_notification    

    respond_to do |format|
      format.js { render layout: false, content_type: 'text/javascript' }
    end
  end

  def destroy
    @group_membership = find_group_membership
    @id = @group_membership.id

    @group = @group_membership.group

    @group_membership.destroy

    respond_to do |format|
      format.js { render layout: false, content_type: 'text/javascript' }
    end
  end


  private

  def create_notifications
    @group.moderators.each do |moderator|
      Notification.create({recipient: moderator, actor: @group_membership.user, action: "#{@group.name}に参加", notifiable: @group}) unless (moderator == current_user)
    end

    Notification.create({recipient: @group.owner, actor: @group_membership.user, action: "#{@group.name}に参加", notifiable: @group}) unless (@group.owner == current_user)
  end

  def create_notification
    return unless group_membership_params[:status] == "accepted"
    Notification.create({recipient: @group_membership.user, actor: current_user, action: "#{@group.name}の参加を許可", notifiable: @group})
  end

  def find_group
    @group ||= Group.find(params[:group_id])
  end

  def find_group_membership
    @group_membership ||= GroupMembership.find(params[:id])
  end

  def check_existing_membership
    @group_membership = current_user.group_memberships.find_by(group_id: params[:group_id])
    return unless @group_membership.present?
    return accept_invitation! if @group_membership.invited?
    flash[:alert] = "もうすでにメンバーか招待済みです。"
    redirect_to group_path(params[:group_id])
  end

  def accept_invitation!
    @group_membership.update(status: :accepted)
    group = @group_membership.group
    flash[:success] = "#{group.name}に参加しました。"
    redirect_to group_path(group)
  end

  def ensure_moderator!
    @group_membership = find_group_membership
    group = @group_membership.group
    
    return if group.owner == current_user

    current_user_group_membership = current_user.group_memberships.find_by(group: group)
    return if current_user_group_membership.moderator?
    flash[:alert] = "グループ管理者以外編集できません。"
    redirect_to group_path(group)
  end

  def group_membership_params
    params.require(:group_membership).permit(:role, :status)
  end
end
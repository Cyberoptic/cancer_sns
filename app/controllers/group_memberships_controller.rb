class GroupMembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    current_user.group_memberships.create(group_id: params[:group_id])
    
    respond_to do |format|
      format.js {}
    end
  end

end
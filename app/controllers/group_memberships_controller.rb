class GroupMembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.group_memberships.create(group_id: params[:group_id])
    
    respond_to do |format|
      format.js {}
    end
  end

end
class GroupDiscoveriesController < ApplicationController
  def index
    if params[:group_search] && params[:group_search][:keyword].present?
      @groups = Group.search(params[:group_search][:keyword])
    end

    @group_search = GroupSearch.new(params[:group_search])
    @groups_ordered_by_group_membership_counts = Group.order_by_group_membership_counts
    @groups_ordered_by_created_at = Group.order_by_created_at
  end
end

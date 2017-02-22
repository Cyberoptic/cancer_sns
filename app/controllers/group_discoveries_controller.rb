class GroupDiscoveriesController < ApplicationController
  def index
    if params[:group_search] && params[:group_search][:keyword].present?
      @groups = Group.is_public.search(params[:group_search][:keyword])
    end

    @group_search = GroupSearch.new(params[:group_search])
    @groups_ordered_by_group_membership_counts = Group.is_public.order_by_group_membership_counts
    @groups_ordered_by_created_at = Group.is_public.order_by_created_at
  end
end

class UsersController < ApplicationController
	before_action :authenticate_user!

	def index
    if params[:user]
      @users = User.search(params[:user][:keyword_search])
    elsif params[:user_search]			
			@users = User.filter(params[:user_search].slice(:name_search, :prefecture, :partner_relationship, :partner_age, :cancer_type, :cancer_stage))
      @users.find_child_by_age_range(min: params[:user_search][:child_age_min], max: params[:user_search][:child_age_max])
		else
			@users = User.limit(5).decorate			
		end
    @search = UserSearch.new(params[:user_search])
	end
    
  def show
    @user = User.find(params[:id]).decorate
    # implement later
    # @suggested_users = User.limit(5)
  end  

  def pending_requests
  	user = User.find(params[:user_id])
  	@requests = user.pending_requests
  end 

  def friends
  	@user = User.find(params[:user_id]).decorate
  	@friends = @user.friends.decorate
  end
    
end

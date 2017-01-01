class UsersController < ApplicationController
	before_action :authenticate_user!

	def index		
		if params[:user_search]			
			@users = User.is_public.filter(params[:user_search].slice(:profession, :partner_age, :cancer_type, :cancer_stage, :hospital, :treatment, :birthday)).decorate			
			@search = UserSearch.new(params[:user_search])			
		else
			@users = User.is_public.decorate
			@search = UserSearch.new
		end
	end
    
  def show
    @user = User.find(params[:id]).decorate
    # implement later
    @suggested_users = User.all
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

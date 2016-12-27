class UsersController < ApplicationController
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
    @suggested_users = User.all
  end   
    
end

class UsersController < ApplicationController
	def index
		if params[:search]			
			@users = User.is_public.filter(params[:search].slice(:profession, :partner_age, :cancer_type, :cancer_stage, :hospital, :treatment, :birthday)).decorate	
		else
			@users = User.is_public.decorate
		end
	end
    
    def show
        @user = User.find(params[:id])
    end   
    
end

class UsersController < ApplicationController
	def index
		if params[:search]			
			@users = User.is_public.filter(params[:search].slice(:profession, :partner_age, :cancer_type, :cancer_stage, :hospital, :treatment, :birthday))			
		else
			@users = User.is_public.all
		end
	end
end

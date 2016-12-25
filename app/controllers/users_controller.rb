class UsersController < ApplicationController
	def index

		if params[:search]			
			@users = User.filter(params[:search].slice(:profession, :partner_age, :cancer_type, :cancer_stage, :hospital, :treatment, :birthday))			
		else
			@users = User.all
		end
	end
end

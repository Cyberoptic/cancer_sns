class UsersController < ApplicationController
	def index
		if params[:search]
			@users = User.filter(params.slice(:profession, :partner_age, :cancer_type, :cancer_stage, :hospital, :treatment, :birthday))
		end

		@users = User.all
	end
end

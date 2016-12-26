class UserSearch
	include ActiveModel::Model

	attr_accessor :nickname, :email, :password, :password_confirmation, :photo, :first_name, :last_name, :first_name_katakana, :last_name_katakana, :birthday, :gender, :email, :partner_age, :cancer_type, :cancer_stage, :treatment, :area, :treatment, :profession, :hospital, :problems, :profile_completed, :is_public, :show_name, :show_profession, :show_partner_age, :show_cancer_type, :show_cancer_stage, :show_hospital, :show_treatment, :show_birthday, :show_problems, :show_area

	def initialize(args)
		args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
	end
end
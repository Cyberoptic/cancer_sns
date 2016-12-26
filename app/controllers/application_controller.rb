class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_user_is_public, unless: :devise_controller?

  protected

  def ensure_user_is_public
    return unless user_signed_in?
    return if current_user.profile_completed?
    flash[:success] = "ユーザー登録を完了してください。"
    redirect_to edit_user_registration_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :provider, :uid) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:nickname, :email, :password, :password_confirmation, :photo, :first_name, :last_name, :first_name_katakana, :last_name_katakana, :birthday, :gender, :email, :partner_age, :cancer_type, :cancer_stage, :treatment, :area, :treatment, :profession, :hospital, :problems, :profile_completed, :is_public, :show_name, :show_profession, :show_partner_age, :show_cancer_type, :show_cancer_stage, :show_hospital, :show_treatment, :show_birthday, :show_problems, :show_area) }
  end

end

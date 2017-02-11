class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, prepend: true

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_user_is_public, unless: :devise_controller?

  protected

  def ensure_user_is_public
    return unless user_signed_in?
    return if current_user.profile_completed?
    flash[:success] = "ご登録ありがとうございます！サービスをよりご活用いただくために、もう少しあなたのことを教えてください。"
    redirect_to edit_user_registration_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :provider, :uid) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:nickname, :email, :password, :password_confirmation, :current_password, :photo, :first_name, :last_name, :first_name_katakana, :last_name_katakana, :birthday, :gender, :email, :partner_age, :cancer_type, :cancer_stage, :treatment, :area, :treatment,:treatment_content, :prefecture, :profession, :hospital, :problems, :profile_completed, :is_public, :name_visibility, :profession_visibility, :partner_age_visibility, :partner_relationship_visibility, :cancer_type_visibility, :cancer_stage_visibility, :hospital_visibility, :treatment_visibility, :birthday_visibility, :problems_visibility, :area_visibility, :partner_relationship, :introduction, :other_treatment, treatment_ids: [], children_attributes: [:id, :age, :gender, :_destroy]) }
  end

end

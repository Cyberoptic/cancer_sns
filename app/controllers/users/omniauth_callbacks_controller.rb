
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user
    else      
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      flash[:success] = "メールアドレスを入力してください。"
      redirect_to new_user_registration_url
    end
  end

  def failure
    flash[:alert] = "エラーが起こりました。しばらくしてからもう一度試してください。"
    redirect_to root_path
  end
end
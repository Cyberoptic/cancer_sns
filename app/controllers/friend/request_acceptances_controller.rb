class Friend::RequestAcceptancesController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.accept_request(@user)
    respond_to do |format|
      format.html {}
      format.js {}
    end   
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.decline_request(@user)
    respond_to do |format|
      format.html {}
      format.js {}
    end    
  end
end

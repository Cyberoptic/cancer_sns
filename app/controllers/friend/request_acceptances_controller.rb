class Friend::RequestAcceptancesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_existing_friendship!

  def create    
    current_user.accept_request(@user)
    @user.chat_rooms.create!(title: "#{@user.name}-#{current_user.name}")
    respond_to do |format|
      format.html {}
      format.js {}
      format.json { render json: 200 }
    end   
  end
  
  private

  def ensure_existing_friendship!
    @user = find_user    
    return if HasFriendship::Friendship.find_by(friend_id: @user.id, friendable_id: current_user.id)
    flash[:alert] = "ユーザーと友達ではありません。"
    redirect_to root_path
  end

  def find_user
    @user ||= User.find(params[:user_id])
  end
end

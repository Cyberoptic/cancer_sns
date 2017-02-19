class Friend::RequestsController < ApplicationController
	before_action :authenticate_user!
  before_action :check_existing_friendship!, only: :create

  def index
    @pending_requests = current_user.pending_requests.paginate(page: params[:page], per_page: 20)
    @sent_requests = current_user.sent_requests.paginate(page: params[:page], per_page: 20)
  end
  
  def create
    @user = User.find(params[:user_id])
    current_user.friend_request(@user)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  private

  def check_existing_friendship!
    @user = find_user    
    return unless HasFriendship::Friendship.find_by(friend_id: @user.id, friendable_id: current_user.id)
    flash[:alert] = "ユーザーともうすでに友達です。"
    redirect_to root_path
  end

  def find_user
    @user ||= User.find(params[:user_id])
  end
end

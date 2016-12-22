class FriendRequestsController < ApplicationController
    
    def create
        @user = User.find(params[:user_id])
        current_user.friend_request(@user)
        redirect_to user_path(params[:user_id])
    end
    
end

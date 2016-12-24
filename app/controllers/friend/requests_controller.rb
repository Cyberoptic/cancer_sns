class Friend::RequestsController < ApplicationController
    
    def create
        @user = User.find(params[:user_id])
        current_user.friend_request(@user)
        redirect_to user_path(params[:user_id])
    end
    
    def destroy
        @user = User.find(params[:user_id])
        @user.decline_request(current_user)
        redirect_to user_path(params[:user_id])
    end
    
    
end

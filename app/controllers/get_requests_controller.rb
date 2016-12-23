class GetRequestsController < ApplicationController
    
    def create
        @user = User.find(params[:user_id])
        current_user.accept_request(@user)
        redirect_to user_path(current_user.id)        
    end

    def update
        @user = User.find(params[:user_id])
        current_user.decline_request(@user)
        redirect_to user_path(current_user.id)        
    end
    
    def destroy
        @user = User.find(params[:user_id])
        current_user.remove_friend(@user)
        redirect_to user_path(current_user.id)        
    end
    
end

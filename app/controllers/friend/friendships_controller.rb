class Friend::FriendshipsController < ApplicationController
    
    def destroy
        @user = User.find(params[:user_id])
        current_user.remove_friend(@user)
        redirect_to user_path(current_user.id)        
    end
    
end

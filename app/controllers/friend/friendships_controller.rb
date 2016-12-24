class Friend::FriendshipsController < ApplicationController

    def destroy
        @user = User.find(params[:user_id])
        current_user.remove_friend(@user)
        respond_to do |format|
          format.html {}
          format.js {}
        end
    end    
    
end

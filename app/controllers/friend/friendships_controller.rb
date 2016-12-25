class Friend::FriendshipsController < ApplicationController
	before_action :authenticate_user!

  def destroy
    @user = User.find(params[:id])    
    current_user.remove_friend(@user)    

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end    
    
end

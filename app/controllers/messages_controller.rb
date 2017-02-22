class MessagesController < ApplicationController
  before_action :authenticate_user!
  
  def create    
    message = current_user.messages.create!(photo: params[:file], chat_room_id: params[:chat_room_id])
    respond_to do |format|
      format.json { render json: :no_head }
    end 
  end
end
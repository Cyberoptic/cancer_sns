class ChatRoomSearchesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    if params[:message_search]
      @chat_rooms = current_user.chat_rooms.find_with_name(params[:message_search][:name])
    else
      @chat_rooms = current_user.chat_rooms.includes(:member, :user)
    end
  end
end

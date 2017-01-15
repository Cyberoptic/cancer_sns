require 'rails_helper'

RSpec.describe ChatRoomsController, type: :controller do
  describe 'GET #index' do
    before do
      user = create(:user)
      sign_in user
      get :index
    end

    it 'render index page' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before do
      user = create(:user)
      sign_in user
      chat_room = create(:chat_room, user: user, member: create(:user))
      get :show, params: { id: chat_room.id }
    end

    it 'render index page' do
      expect(response).to render_template(:show)
    end
  end
end

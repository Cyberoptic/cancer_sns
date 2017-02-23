require 'rails_helper'

RSpec.describe ChatRoomsController, type: :controller do
  describe "GET #index" do
    context "when there is a chat room present with messages" do
      it 'renders index page' do
        user = create(:user)
        chat_room = create(:chat_room, user: user, member: create(:user))
        create(:message, chat_room: chat_room, user: user)

        sign_in user
        get :index

        expect(response).to render_template(:index)
      end
    end

    context "when there is a chat room present with no messages" do
      it 'renders index page' do
        user = create(:user)
        chat_room = create(:chat_room, user: user, member: create(:user))

        sign_in user
        get :index

        expect(response).to render_template(:index)
      end
    end

    context "when there is no chat room present" do
      it 'does not render the index page' do
        user = create(:user)

        sign_in user
        get :index

        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #show' do
    it 'render index page' do
      user = create(:user)
      chat_room = create(:chat_room, user: user, member: create(:user))

      sign_in user
      get :show, params: { id: chat_room.id }

      expect(response).to render_template(:show)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new chat room" do
        # setup
        user = create(:user)
        another_user = create(:user)

        # exercise
        sign_in user
        # exercise + verify at once
        expect {
          post :create, user_id: another_user.id
        }.to change(ChatRoom, :count).by(1)

      end
    end
  end

end

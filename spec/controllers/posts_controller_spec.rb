require 'rails_helper'
require 'spec_helper'
require 'rspec/rails'
require 'devise'

RSpec.describe PostsController, type: :controller do

  describe 'GET #index' do
    it 'render index page' do
      user = create(:user)

      sign_in user
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates new post' do
        user = create(:user)

        sign_in user

        expect {
          post :create, post: attributes_for(:post, user_id: user.id), format: :js
        }.to change(Post, :count).by(1)
      end
    end
    context 'with invalid attributes' do
      it 'doesnt create a new post' do
        user = create(:user)

        sign_in user

        expect {
          post :create, post: attributes_for(:post, content: nil, user_id: user.id), format: :js
        }.to change(Post, :count).by(0)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates post' do
        user = create(:user)
        post = create(:post, user_id: user.id)
        request.env["HTTP_REFERER"] = "http://localhost:3000"

        sign_in user
        put :update, id: post.id, post: attributes_for(:post, content: "hello there"), format: :js
        post.reload

        expect(post.content).to eq("hello there")
      end
    end
    context 'with invalid attributes' do
      it "doesn't update the post" do
        user = create(:user)
        post = create(:post, user_id: user.id)
        request.env["HTTP_REFERER"] = "http://localhost:3000"

        sign_in user

        expect {
          put :update,id: post.id, post: attributes_for(:post, content: nil), format: :js        
        }.to_not change(post, :content)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes post' do
      user = create(:user)
      post = create(:post, user_id: user.id)

      sign_in user

      expect {
        delete :destroy, id: post.id, format: :js
      }.to change(Post,:count).by(-1)
    end
  end



end

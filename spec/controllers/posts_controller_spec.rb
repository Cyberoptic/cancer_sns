require 'rails_helper'
require 'spec_helper'
require 'rspec/rails'
require 'devise'

RSpec.describe PostsController, type: :controller do

  describe 'GET #index' do
    it 'render index page' do
      user = create(:user)
      puts user.email
      sign_in user
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'renders new page' do
      user = FactoryGirl.create(:user)
      sign_in user
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #show' do
    it 'renders show page' do
      user = FactoryGirl.create(:user)
      sign_in user
      post = FactoryGirl.create(:post, user_id: user.id)
      get :show, id: post.id
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    it 'redners edit page' do
      user = FactoryGirl.create(:user)
      sign_in user
      post = FactoryGirl.create(:post,user_id: user.id)
      get :edit, id: post.id
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates new post' do
        user = FactoryGirl.create(:user)
        sign_in user
        expect {post :create, post: FactoryGirl.attributes_for(:post, user_id: user.id)}.to change(Post, :count).by(1)
      end
      it 'redirects to show page' do
        user = FactoryGirl.create(:user)
        sign_in user
        post :create, post: FactoryGirl.attributes_for(:post)
        expect(response).to redirect_to post_path(assigns[:post])
      end
    end
    context 'with invalidd attributes ' do
      it 'doesnt create a new post' do
        user = FactoryGirl.create(:user)
        sign_in user
        expect {post :create, post: FactoryGirl.attributes_for(:post, content: nil, user_id: user.id)}.to change(Post, :count).by(0)
        expect(response).to render_template :new
      end
    end
  end

  describe ' PUT #update' do
    context 'with valid attributes' do
      it 'updates post' do
        user = create(:user)
        post = create(:post,user_id: user.id)
        put :update,id: post.id,post: FactoryGirl.attributes_for(:post,content: "hello there")
        post.reload
        expect(post.content).to eq("hello there")
      end
      it 'redirects to show path' do
        user = create(:user)
        post = create(:post,user_id: user.id)
        put :update, id: post.id, post: FactoryGirl.attributes_for(:post, content: "hello there")
        post.reload
        expect(response).to redirect_to post_path(assigns[:post])
      end
    end
    context 'with invalid attributes' do
      it 'renders edit' do
        user = create(:user)
        post = create(:post, user_id: user.id)
        put :update,id: post.id, post: FactoryGirl.attributes_for(:invalid_post)
        post.reload
        expect(response).to render_template :edit
      end
    end
  end

  describe ' Delete #destroy' do
    it 'deletes post' do
      user = create(:user)
      post=create(:post,user_id: user.id)
      expect {delete :destroy,id: post.id}.to change(Post,:count).by(-1)
    end
    it 'redirects to posts path' do
      user= create(:user)
      post=create(:post,user_id: user.id)
      expect(response).to redirect_to posts_path
    end
  end



end

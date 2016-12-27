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
      post = FactoryGirl.create(:post)
      get :show, id: post.id
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    it 'redners edit page' do
      user = FactoryGirl.create(:user)
      sign_in user
      post = FactoryGirl.create(:post)
      get :edit, id: post.id
    end
  end

  describe 'POST #create' do
    context 'with invalid attributes' do
      it 'creates new post' do
      end
      it 'redirects to show page' do
      end
    end
    context 'with validd attributes ' do
      it 'renders new action' do
      end
    end
  end

  describe ' PUT #update' do
    context 'with valid attributes' do
      it 'updates post' do
      end
      it 'redirects to edit' do
      end
    end
    context 'with invalid attributes' do
      it 'renders edit' do
      end
    end
  end

  describe ' Delete #destroy' do
    it 'deletes post' do
    end
  end



end

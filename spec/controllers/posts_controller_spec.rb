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

end

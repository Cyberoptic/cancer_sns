require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#Create new session" do
    it 'signins new user' do
      user = FactoryGirl.create(:user)
      sign_in user
      expect(controller.current_user).not_to equal(nil)
    end
  end

  describe "GET #index" do
  	it "renders the index template" do
  		user = create(:user)

  		sign_in user
  		get :index

  		expect(response).to render_template :index
  	end
  end

  describe "GET #show" do
  	it "renders the show template" do
  		user = create(:user)

  		sign_in user
  		get :show, id: user.id 

  		expect(response).to render_template :show
  	end
  end

  describe "GET #friends" do
  	it "renders the friends template" do
  		user = create(:user)

  		sign_in user
  		get :friends, user_id: user.id

  		expect(response).to render_template :friends
  	end
  end
end

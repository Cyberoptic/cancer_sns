require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe "GET #index" do
    it "renders index page" do
      # setup
      user = create(:user)
      # exercise
      sign_in user
      get :index
      # verify
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "renders a specific group's page(show template)" do

    end
  end
end

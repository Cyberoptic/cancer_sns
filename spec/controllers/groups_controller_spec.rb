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
			# setup
			user = create(:user)
			group = create(:group)
			# exercise
			sign_in user
			get :show, id: group.id
			# verify
			expect(response).to render_template(:show)
    end
  end

	describe "POST #create" do
		context "when attributes are valid" do
			it "creates a new group" do
				# setup
				user = create(:user)
				# exercise + verify
				sign_in user
				expect {
					post :create, group: {name: "Group1"}
				}.to change(Group, :count).by(1)
			end
		end
	end
end

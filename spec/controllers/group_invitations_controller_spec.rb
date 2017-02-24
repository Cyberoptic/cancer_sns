require 'rails_helper'

RSpec.describe GroupInvitationsController, type: :controller do
  describe "GET #index" do
    context "when user is not signed in" do
      it "redirects the user to new_user_session_path" do
        get :index, group_id: create(:group).id

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is a member" do
      it "renders the index template" do
        user = create(:user)
        group = create(:group)
        create(:group_membership, group: group, user: user) 

        get :index, group_id: group.id

        expect(response).to render_template :index
      end
    end

    context "when user is not a member" do
      it "does not render the index template" do
        user = create(:user)
        group = create(:group)

        get :index, group_id: group.id

        expect(response).to redirect_to group_path(group)
      end
    end
  end

  describe "POST #create" do
    context "when user is a member" do
      it "creates an invitation" do
        user = create(:user)
        user_2 = create(:user)
        group = create(:group)
        create(:group_membership, group: group, user: user) 

        expect {
          post :create, params: { group_id: group.id, group_membership: {user_id: user_2.id} }
        }.to change(GroupMembership, :count).by(1)
        expect(GroupMembership.last.status).to eq(:invited)
      end
    end

    context "when user is not a member" do
      it "does not create an invitation" do
        user = create(:user)
        user_2 = create(:user)
        group = create(:group)

        expect {
          post :create, params: { group_id: group.id, group_membership: {user_id: user_2.id} }
        }.to change(GroupMembership, :count).by(0)
      end
    end
  end
end

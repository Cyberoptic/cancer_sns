require 'rails_helper'

RSpec.describe GroupMembershipsController, type: :controller do
  describe "POST #create" do
    
    context "when user is signed in" do
      it "doesn't redirect to new_user_session_path" do
        group = create(:group)
        user = create(:user)

        sign_in user
        post :create, params: {group_id: group.id}

        expect(response).to_not redirect_to new_user_session_path
      end
    end
    
    context "when user is not signed in" do
      it "redirects to new_user_session_path" do
        group = create(:group)

        post :create, params: {group_id: group.id}

        expect(response).to redirect_to new_user_session_path
      end
    end
    
    context "when attributes are valid" do
      it "creates a group membership" do
        user = create(:user)
        group = create(:group)

        sign_in user

        expect {
          post :create, params: { group_id: group.id }
        }.to change(GroupMembership, :count).by(1)
        
      end
    end
  end

end

require 'rails_helper'

RSpec.describe GroupMembershipsController, type: :controller do
  describe "POST #create" do
    context "when user is signed in" do
      it "doesn't redirect to new_user_session_path" do
        group = create(:group)
        user = create(:user)

        sign_in user
        post :create, params: {group_id: group.id}, format: :js

        expect(response).to_not redirect_to new_user_session_path
      end
    end
    
    context "when user is not signed in" do
      it "is unauthorized" do
        group = create(:group)

        post :create, params: {group_id: group.id}, format: :js

        expect(response.status).to eq(401)
      end
    end
    
    context "when attributes are valid" do
      it "creates a group membership" do
        user = create(:user)
        group = create(:group)

        sign_in user

        expect {
          post :create, params: { group_id: group.id }, format: :js
        }.to change(GroupMembership, :count).by(1)
      end
    end

    context "when the group is accessible by everyone" do
      it "creates a accepted membership" do
        group = create(:group, access_type: :accessible_to_everyone)
        user = create(:user)

        sign_in user
        post :create, params: {group_id: group.id}, format: :js

        expect(GroupMembership.last.status).to eq("accepted")
      end
    end

    context "when the group needs owner permission" do
      it "creates a pending group membership" do
        group = create(:group, access_type: :needs_owner_permission)
        user = create(:user)

        sign_in user
        post :create, params: {group_id: group.id}, format: :js

        expect(GroupMembership.last.status).to eq("pending")
      end
    end
  end

  describe "#PUT update" do
    context "when user is moderator for the group" do
      it "updates the group membership" do
        user = create(:user)
        another_user = create(:user)
        group = create(:group, name: "Group")
        create(:group_membership, user: user, group: group, role: :moderator)
        group_membership = create(:group_membership, user: another_user, group: group, role: :member)

        sign_in user
        put :update, params: {id: group_membership.id, group_membership: {role: "moderator"}}, format: :js
        group_membership.reload

        expect(group_membership.role).to eq("moderator")
      end
    end

    context "when user is not a moderator for the group" do
      it "does not update the group membership" do
        user = create(:user)
        another_user = create(:user)
        group = create(:group, name: "Group")
        create(:group_membership, user: user, group: group, role: :member)
        group_membership = create(:group_membership, user: another_user, group: group, role: :member)

        sign_in user
        put :update, params: {id: group_membership.id, group_membership: {role: "moderator"}}, format: :js
        group_membership.reload

        expect(group_membership.role).to eq("member")
      end
    end
  end
end

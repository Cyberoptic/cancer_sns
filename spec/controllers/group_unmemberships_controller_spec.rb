require 'rails_helper'

RSpec.describe GroupUnmembershipsController, type: :controller do
  describe "POST #create" do
    context "when user is owner of group" do
      it "redirects the user" do
        user = create(:user)
        group = create(:group, owner: user)
        create(:group_membership, user_id: user.id, group_id: group.id)

        sign_in user
        post :create, params: { group_id: group.id }, format: :js

        expect(response).to redirect_to group_path(group)
      end
    end

    context "when user is subscribed to the group" do
      it "should unsubscribe the user from the group" do 
        user = create(:user)
        group = create(:group)

        sign_in user
        create(:group_membership, user_id: user.id, group_id: group.id)

        expect {
          post :create, params: { group_id: group.id }, format: :js
        }.to change(GroupMembership, :count).by(-1)
      end
    end

    context "when user is not subscribed to the group" do
      it "redirects to group path" do
        group = create(:group)
        user = create(:user)

        sign_in user
        post :create, params: { group_id: group.id }, format: :js
        
        expect(response).to redirect_to(group_path(group))
      end
    end
  end
end

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

  describe "GET #edit" do
    context "when user is moderator" do
      it "renders the edit template" do
        user = create(:user)
        group = create(:group)
        create(:group_membership, user: user, group: group, role: :moderator)

        sign_in user
        get :edit, params: {id: group.id}

        expect(response).to render_template :edit
      end
    end

    context "when user is not moderator" do
      it "redirects to group_path" do
        user = create(:user)
        group = create(:group)
        create(:group_membership, user: user, group: group, role: :member)

        sign_in user
        get :edit, params: {id: group.id}

        expect(response).to redirect_to group_path(group)
      end
    end
  end

  describe "PUT #update" do
    context "when user is moderator" do
      context "when attributes are valid" do
        it "updates the group information" do
          user = create(:user)
          group = create(:group, name: "Group")
          create(:group_membership, user: user, group: group, role: :moderator)

          sign_in user
          put :update, params: {id: group.id, group: {name: "New Group Name"}}
          group.reload

          expect(group.name).to eq("New Group Name")
        end

        it "redirects to group_path" do
          user = create(:user)
          group = create(:group, name: "Group")
          create(:group_membership, user: user, group: group, role: :moderator)

          sign_in user
          put :update, params: {id: group.id, group: {name: "New Group Name"}}

          expect(response).to redirect_to group_path(group)
        end
      end

      context "when attributes are invalid" do
        it "does not update the group information" do
          user = create(:user)
          group = create(:group, name: "Group")
          create(:group_membership, user: user, group: group, role: :moderator)

          sign_in user
          put :update, params: {id: group.id, group: {name: nil}}
          group.reload

          expect(group.name).to eq("Group")
        end

        it "renders the edit template" do
          user = create(:user)
          group = create(:group, name: "Group")
          create(:group_membership, user: user, group: group, role: :moderator)

          sign_in user
          put :update, params: {id: group.id, group: {name: nil}}
          
          expect(response).to render_template :edit
        end
      end
    end

    context "when user is not moderator" do
      it "redirects to group_path" do
        user = create(:user)
        group = create(:group)
        create(:group_membership, user: user, group: group, role: :member)

        sign_in user
        put :update, params: {id: group.id, group: {name: nil}}

        expect(response).to redirect_to group_path(group)
      end
    end
  end
end

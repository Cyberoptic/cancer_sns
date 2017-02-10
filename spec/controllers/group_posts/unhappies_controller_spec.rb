require 'rails_helper'

RSpec.describe GroupPosts::UnhappiesController, type: :controller do
  describe "POST #create" do
    context "when attriutes are valid" do
      it "triggers #unhappy" do
        # setup
        user = create(:user)
        group = create(:group)
        group_post = create(:group_post, user_id: user.id, group_id: group.id)
        allow(controller).to receive(:current_user).and_return(user)
        allow(user).to receive(:unhappy).with(group_post).and_return(true)
        # exercise
        sign_in user
        post :create, params: { group_post_id: group_post.id }, format: :js
        # verify
        expect(controller.current_user).to have_received(:unhappy)
      end
    end
  end
end

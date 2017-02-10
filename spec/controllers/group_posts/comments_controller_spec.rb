require 'rails_helper'

RSpec.describe GroupPosts::CommentsController, type: :controller do
  describe "POST #create" do
    context "with valid attriutes" do
      it "should create a new comment" do
        # setup
        user = create(:user)
        group = create(:group)
        group_post = create(:group_post, user_id: user.id, group_id: group.id)

        # exercise + verify
        sign_in user
        expect {
          post :create, params: { comment: {text: "A comment!", user_id: user.id }, group_post_id: group_post.id }, format: :js
        }.to change(Comment, :count).by(1)
      end
    end
    context 'with invalid attributes' do
      it 'should not create a new comment' do
        # setup
        user = create(:user)
        group = create(:group)
        group_post = create(:group_post, user_id: user.id, group_id: group.id)

        # exercise + verify
        sign_in user
        expect {
          post :create, params: { comment: {text: nil, user_id: user.id }, group_post_id: group_post.id }, format: :js
        }.to change(Comment, :count).by(0)

      end
    end
  end
end

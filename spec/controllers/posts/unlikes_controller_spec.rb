require 'rails_helper'

RSpec.describe Posts::UnlikesController, type: :controller do
  describe "#create" do
    it "unlikes the post with :post_id" do
      user = create(:user)
      user_post = create(:post, user_id: user.id)

      create(:like, user_id: user.id, post_id: user_post.id, post_type: user_post.class.name)

      sign_in user
      
      expect {
        post :create, params: { post_id: user_post.id }, format: :js
      }.to change(Like, :count).by(-1)
      
    end
  end
end

require 'rails_helper'

RSpec.describe UnlikesController, type: :controller do
  describe "#create" do
    it "unlikes the post with :post_id" do
      user = create(:user)
      post = create(:post)
      like = create(:like, user_id: user.id, post_id: post.id)

      expect {
        post :create, params: { post_id: post.id }, format: :js
      }.to change(Like, :count).by(-1)
      
      post.reload
    end
  end
end

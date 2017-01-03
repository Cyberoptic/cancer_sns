require 'rails_helper'

RSpec.describe UnhappiesController, type: :controller do
  describe "#create" do
    it "unhappies the post with :post_id" do
      user = create(:user)
      post = create(:post)
      happy = create(:happy, user_id: user.id, post_id: post.id)

      expect {
        post :create, params: { post_id: post.id }, format: :js
      }.to change(Happy, :count).by(-1)

      post.reload  
    end
  end
end

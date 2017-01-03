require 'rails_helper'

RSpec.describe UnsadsController, type: :controller do
  describe "#create" do
    it "unsads the post with :post_id" do
      user = create(:user)
      post = create(:post)
      sad = create(:sad, user_id: user.id, post_id: post.id)

      expect {
        post :create, params: { post_id: post.id }, format: :js
      }.to change(Sad, :count).by(-1)
      
      post.reload 
    end
  end
end

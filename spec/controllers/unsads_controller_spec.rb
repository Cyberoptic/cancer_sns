require 'rails_helper'

RSpec.describe UnsadsController, type: :controller do
  describe "#create" do
    it "unsads the post with :post_id" do
      user = create(:user)
      user_post = create(:post, user_id: user.id)
      
      create(:sad, user_id: user.id, post_id: user_post.id)

      sign_in user
      
      expect {
        post :create, params: { post_id: user_post.id }, format: :js
      }.to change(Sad, :count).by(-1)
       
    end
  end
end

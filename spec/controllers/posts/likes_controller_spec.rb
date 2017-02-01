require 'rails_helper'

RSpec.describe Posts::LikesController, type: :controller do
  describe "POST #create" do
    context "when attriutes are valid" do 
      it "creates a like" do 
        user = create(:user)
        user_post = create(:post, user_id: user.id)
        

        sign_in user
        allow(user).to receive(:like).with(user_post)
        post :create, params: { post_id: user_post.id }, format: :js

        expect(user).to have_received(:like)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Comments::LikesController, type: :controller do
  describe "POST #create" do
    context "when attriutes are valid" do 
      it "triggers #like" do 
        user = create(:user)
        user_post = create(:post, user_id: user.id)
        comment = create(:comment, post: user_post, user_id: user.id)
        allow(controller).to receive(:current_user).and_return(user)                
        allow(user).to receive(:like).with(comment).and_return(true)
        
        sign_in user
        post :create, params: { comment_id: comment.id }, format: :js

        expect(controller.current_user).to have_received(:like)
      end
    end
  end
end

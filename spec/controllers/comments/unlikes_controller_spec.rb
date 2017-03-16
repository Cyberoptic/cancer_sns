require 'rails_helper'

RSpec.describe Comments::UnlikesController, type: :controller do
  describe "POST #create" do
    it "triggers #unlike" do 
      user = create(:user)
      user_post = create(:post, user_id: user.id)
      comment = create(:comment, post: user_post, user_id: user.id)
      allow(controller).to receive(:current_user).and_return(user)                
      allow(user).to receive(:unlike).with(comment).and_return(true)
      
      sign_in user
      post :create, params: { comment_id: comment.id }, format: :js

      expect(controller.current_user).to have_received(:unlike)
    end    
  end
end

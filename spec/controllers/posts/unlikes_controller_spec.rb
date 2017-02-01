require 'rails_helper'

RSpec.describe Posts::UnlikesController, type: :controller do
  describe "#create" do
    it "triggers #unlike" do 
      user = create(:user)
      user_post = create(:post, user_id: user.id)
      allow(controller).to receive(:current_user).and_return(user)                
      allow(user).to receive(:unlike).with(user_post).and_return(true)
      
      sign_in user
      post :create, params: { post_id: user_post.id }, format: :js

      expect(controller.current_user).to have_received(:unlike)
    end    
  end
end

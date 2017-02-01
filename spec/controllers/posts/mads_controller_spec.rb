require 'rails_helper'

RSpec.describe Posts::MadsController, type: :controller do
  describe "POST #create" do
    it "triggers #mad" do 
      user = create(:user)
      user_post = create(:post, user_id: user.id)
      allow(controller).to receive(:current_user).and_return(user)                
      allow(user).to receive(:mad).with(user_post).and_return(true)
      
      sign_in user
      post :create, params: { post_id: user_post.id }, format: :js

      expect(controller.current_user).to have_received(:mad)
    end
  end
end

require 'rails_helper'

RSpec.describe Posts::SadsController, type: :controller do
  describe "POST #create" do
    context "when attriutes are valid" do 
      it "triggers #sad" do 
        user = create(:user)
        user_post = create(:post, user_id: user.id)
        allow(controller).to receive(:current_user).and_return(user)                
        allow(user).to receive(:sad).with(user_post).and_return(true)
        
        sign_in user
        post :create, params: { post_id: user_post.id }, format: :js

        expect(controller.current_user).to have_received(:sad)
      end
    end
  end
end

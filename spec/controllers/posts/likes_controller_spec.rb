require 'rails_helper'

RSpec.describe Posts::LikesController, type: :controller do
  let(:user) { create(:user) }  

  describe "POST #create" do
    context "when attriutes are valid" do 
      it "triggers #like" do 
        user = create(:user)
        user_post = create(:post, user_id: user.id)
        allow(controller).to receive(:current_user).and_return(user)                
        allow(user).to receive(:like).with(user_post).and_return(true)
        
        sign_in user
        post :create, params: { post_id: user_post.id }, format: :js

        expect(controller.current_user).to have_received(:like)
      end
    end
  end
end

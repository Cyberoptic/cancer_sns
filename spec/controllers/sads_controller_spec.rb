require 'rails_helper'

RSpec.describe SadsController, type: :controller do
  describe "POST #create" do
		context "when attriutes are valid" do	
			it "creates a sad" do 
				user = create(:user)
				post = create(:post)

				sign_in user

				expect {
					post :create, params: { post_id: post.id }, format: :js
				}.to change(Sad, :count).by(1)

				post.reload
			end
		end
	end
end

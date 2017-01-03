require 'rails_helper'

RSpec.describe HappiesController, type: :controller do
  describe "POST #create" do
		context "when attriutes are valid" do	
			it "creates a happy" do 
				user = create(:user)
				post = create(:post)

				sign_in user

				expect {
					post :create, params: { post_id: post.id }, format: :js
				}.to change(Happy, :count).by(1)

			end
		end
	end
end

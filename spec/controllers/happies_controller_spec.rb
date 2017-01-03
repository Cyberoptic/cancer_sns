require 'rails_helper'
require 'spec_helper'
require 'rspec/rails'
require 'devise'

RSpec.describe HappiesController, type: :controller do
  describe "POST #create" do
		context "when attriutes are valid" do	
			it "creates a happy" do 
				user = create(:user)
				user_post = create(:post, user_id: user.id)

				sign_in user

				expect {
					post :create, params: { post_id: user_post.id }, format: :js
				}.to change(Happy, :count).by(1)

			end
		end
	end
end

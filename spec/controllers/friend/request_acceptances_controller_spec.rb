require 'rails_helper'

RSpec.describe Friend::RequestAcceptancesController, type: :controller do
	describe "POST #create" do
		context "when user is signed in" do
			it "should accept the friend request" do
				user = create(:user)
				other_user = create(:user)
				other_user.friend_request(user)
				allow(user).to receive(:accept_request).with(other_user)

				post :create, params: { user_id: other_user }

				expect(user).to have_received(:accept_request)
			end
			
		end
	end
end

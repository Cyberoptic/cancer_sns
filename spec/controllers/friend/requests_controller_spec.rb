require 'rails_helper'

RSpec.describe Friend::RequestsController, type: :controller do
	describe "POST #create" do
		context "when a friend request exists" do
			it "should create a new friend request" do
				user = create(:user)
				other_user = create(:user)

				sign_in user

				expect {
					post :create, params: { user_id: other_user.id }, format: :js								
				}.to change(HasFriendship::Friendship, :count).by(2)				
			end
		end

		context "when a friend request does not exist" do
			it "should redirect the user to root path" do
				user = create(:user)
				other_user = create(:user)
				other_user.friend_request(user)		

				sign_in user
				
				expect {
					post :create, params: { user_id: other_user.id }, format: :js								
				}.to change(HasFriendship::Friendship, :count).by(0)	
				expect(response).to redirect_to root_path
			end
		end

	end	
end

require 'rails_helper'

RSpec.describe Friend::UnfriendingsController, type: :controller do
	describe "POST #create" do
		context "when there is an existing relationship" do
			it "should unfriend the user" do
				user = create(:user)
				other_user = create(:user)
				create(:friendship, friendable_id: user.id, friend_id: other_user.id, status: "accepted")
				create(:friendship, friendable_id: other_user.id, friend_id: user.id, status: "accepted")
				

				sign_in user
				expect{
					post :create, params: { user_id: other_user.id }, format: :js						
				}.to change(HasFriendship::Friendship, :count).by(-2)
			end
		end

		context "when there is no existing relationship" do
			it "should not unfriend the user" do
				user = create(:user)
				other_user = create(:user)

				sign_in user
				expect{
					post :create, params: { user_id: other_user.id }, format: :js						
				}.to change(HasFriendship::Friendship, :count).by(0)
				expect(response).to redirect_to root_path
			end
		end
	end
end

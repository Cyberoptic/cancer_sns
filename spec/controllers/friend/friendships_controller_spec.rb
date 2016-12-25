require 'rails_helper'

RSpec.describe Friend::FriendshipsController, type: :controller do
	describe "DELETE #destroy" do
		context "when user is signed in" do
			it "should unfriend the user" do
				user = create(:user)
				other_user = create(:user)
				create(:friendship, friendable_id: user.id, friend_id: other_user.id, status: "accepted")
				create(:friendship, friendable_id: other_user.id, friend_id: user.id, status: "accepted")
				

				sign_in user
				expect{
					delete :destroy, params: { id: other_user.id }, format: :js						
				}.to change(HasFriendship::Friendship, :count).by(-2)
			end
		end

		context "when user is not signed in" do
			it "should not unfriend the user" do
				user = create(:user)
				other_user = create(:user)
				create(:friendship, friendable_id: user.id, friend_id: other_user.id, status: "accepted")
				create(:friendship, friendable_id: other_user.id, friend_id: user.id, status: "accepted")

				delete :destroy, params: { id: other_user.id }, format: :js

				expect(user).to_not receive(:remove_friend)
				expect(response.status).to eq(401)
			end
		end
	end
end
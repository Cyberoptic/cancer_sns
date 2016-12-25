require 'rails_helper'

RSpec.describe User, type: :model do
	describe "profile_incomplete" do
		context "when user is created" do
			it "should be set to true" do
				user = create(:incomplete_user)

				expect(user.profile_incomplete).to eq(true)
			end
		end
	end

	describe "#flag_profile_complete!" do
		context "when user is saved with correct attributes" do
			it "should mark the user's profile as completed" do
				user = create(:incomplete_user)

				user.update(attributes_for(:user))
				user.reload

				expect(user.profile_incomplete).to eq(false)
			end
		end
	end
end

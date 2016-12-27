require 'rails_helper'

RSpec.describe User, type: :model do
	context "when user has set show_name to true" do
		it "does not validate presence of nickname" do
			user = build(:user, show_name: true)
			user.nickname = nil

			expect(user).to be_valid
		end
	end

	context "when user has set show_name to false" do
		it "does validate presence of nickname" do
			user = build(:user, show_name: false)
			user.nickname = nil

			expect(user).to_not be_valid
		end
	end
end

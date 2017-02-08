require 'rails_helper'

RSpec.describe User, type: :model do
	describe "password" do
		context "when password is all lowercase" do
			it "should not be valid" do
				user = build(:user, password: "password", password_confirmation: "password")

				expect(user).to_not be_valid
			end
		end

		context "when password is all uppercase" do
			it "should not be valid" do
				user = build(:user, password: "PASSWORD", password_confirmation: "PASSWORD")

				expect(user).to_not be_valid
			end
		end

		context "has uppercase and lowercase characters and numbers and is not over 8 characters" do
			it "should not be valid" do
				user = build(:user, password: "Pass123", password_confirmation: "Pass123")

				expect(user).to_not be_valid
			end
		end

		context "has uppercase and lowercase characters and numbers and is over 8 characters" do
			it "should be valid" do
				user = build(:user, password: "Password123", password_confirmation: "Password123")

				expect(user).to be_valid
			end
		end
	end

	context "when user has set show_name to true" do
		it "does not validate presence of nickname" do
			user = build(:user, name_visibility: User::SETTING_OPTIONS.first)
			user.nickname = nil

			expect(user).to be_valid
		end
	end

	context "when user has set show_name to false" do
		it "validates presence of nickname" do
			user = build(:user, name_visibility: User::SETTING_OPTIONS.last)
			user.nickname = nil

			expect(user).to_not be_valid
		end
	end


	describe "#posts_visible_for" do
		context "when current_user is self" do
			it "returns all posts" do
				user = create(:user)				
				visible_to_everyone = create(:post, visibility: 0, user: user)
				visible_to_friends = create(:post, visibility: 1, user: user)
				hidden = create(:post, visibility: 2, user: user)

				expect(user.posts_visible_for(current_user: user)).to include(visible_to_friends, visible_to_everyone, hidden)
			end
		end

		context "when current_user is friends with self" do
			it "returns posts visible to friends and visible to everyone" do
				user = create(:user)	
				friend = create(:user)			
				allow(user).to receive(:friends_with?).with(friend).and_return(true)
				visible_to_everyone = create(:post, visibility: 0, user: user)
				visible_to_friends = create(:post, visibility: 1, user: user)
				hidden = create(:post, visibility: 2, user: user)

				expect(user.posts_visible_for(current_user: friend)).to include(visible_to_friends, visible_to_everyone)
			end
		end

		context "when current_user is not friends with self" do
			it "returns posts visible to everyone" do
				user = create(:user)	
				other_user = create(:user)							
				visible_to_everyone = create(:post, visibility: 0, user: user)
				visible_to_friends = create(:post, visibility: 1, user: user)
				hidden = create(:post, visibility: 2, user: user)

				expect(user.posts_visible_for(current_user: other_user)).to include(visible_to_everyone)
			end
		end
	end

	describe "#emotioned_on?" do
		context "when user has not emotioned on the post" do
			it "returns false" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				expect(user.emotioned_on?(post)).to eq(false)
			end
		end

		context "when user has liked a post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				user.like(post)

				expect(user.emotioned_on?(post)).to eq(true)
			end
		end

		context "when user has madded a post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				user.mad(post)

				expect(user.emotioned_on?(post)).to eq(true)
			end
		end

		context "when user has happied a post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				user.happy(post)

				expect(user.emotioned_on?(post)).to eq(true)
			end
		end

		context "when user has sadded a post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				user.sad(post)

				expect(user.emotioned_on?(post)).to eq(true)
			end
		end
	end
end

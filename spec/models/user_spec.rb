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
			user = build(:user, show_name: true)
			user.nickname = nil

			expect(user).to be_valid
		end
	end

	context "when user has set show_name to false" do
		it "validates presence of nickname" do
			user = build(:user, show_name: false)
			user.nickname = nil

			expect(user).to_not be_valid
		end
	end

	describe "#like" do
		it "creates a new like" do
			user = create(:user)
			post = create(:post, user_id: user.id)

			expect {
				user.like(post)
			}.to change(user.likes, :count).by(1)
		end
	end

	describe "#unlike" do
		it "deletes a like" do
			user = create(:user)
			post = create(:post, user_id: user.id)
			create(:like, user_id: user.id, post_id: post.id)

			expect {
				user.unlike(post)
			}.to change(user.likes, :count).by(-1)
		end
	end

	describe "#sad" do
		it "creates a new like" do
			user = create(:user)
			post = create(:post, user_id: user.id)

			expect {
				user.sad(post)
			}.to change(user.sads, :count).by(1)
		end
	end

	describe "#unsad" do
		it "deletes a like" do
			user = create(:user)
			post = create(:post, user_id: user.id)
			create(:sad, user_id: user.id, post_id: post.id)

			expect {
				user.unsad(post)
			}.to change(user.sads, :count).by(-1)
		end
	end

	describe "#happy" do
		it "creates a new like" do
			user = create(:user)
			post = create(:post, user_id: user.id)

			expect {
				user.happy(post)
			}.to change(user.happies, :count).by(1)
		end
	end

	describe "#unhappy" do
		it "deletes a like" do
			user = create(:user)
			post = create(:post, user_id: user.id)
			create(:happy, user_id: user.id, post_id: post.id)

			expect {
				user.unhappy(post)
			}.to change(user.happies, :count).by(-1)
		end
	end

	describe "#liked?" do
		context "when user has liked the post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)	
				user.like(post)

				expect(user.liked?(post)).to eq(true)
			end
		end

		context "when user has not liked the post" do
			it "returns false" do
				user = create(:user)
				post = create(:post, user_id: user.id)	

				expect(user.liked?(post)).to eq(false)
			end
		end
	end

	describe "#sadded?" do
		context "when user has sadded the post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)	
				user.sad(post)				

				expect(user.sadded?(post)).to eq(true)
			end
		end

		context "when user has not sadded the post" do
			it "returns false" do
				user = create(:user)
				post = create(:post, user_id: user.id)	

				expect(user.sadded?(post)).to eq(false)
			end
		end
	end

	describe "#happied?" do
		context "when user has happied the post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)	
				user.happy(post)			

				expect(user.happied?(post)).to eq(true)
			end
		end

		context "when user has not happied the post" do
			it "returns false" do
				user = create(:user)
				post = create(:post, user_id: user.id)	

				expect(user.happied?(post)).to eq(false)
			end
		end
	end
end

require 'rails_helper'

RSpec.describe User, type: :model do	
	describe "#find_child_by_age_range" do		
		context "when no arguments are given" do
			it "returns an empty activerecord object" do
				expect(User.find_child_by_age_range(min: "", max: "")).to eq([])
			end
		end

		context "when min and max is given" do
			it "finds users with children within the age range given" do
				user_1 = create(:user)
				create(:child, age: 1, user: user_1)
				user_2 = create(:user)
				create(:child, age: 10, user: user_2)
				user_3 = create(:user)
				create(:child, age: 15, user: user_3)

				expect(User.find_child_by_age_range(min: 10, max: 15)).to include(user_2, user_3)
				expect(User.find_child_by_age_range(min: 10, max: 15)).to_not include(user_1)
			end
		end

		context "when only min is given" do
			it "returns all users with atleast min" do
				user_1 = create(:user)
				create(:child, age: 1, user: user_1)
				user_2 = create(:user)
				create(:child, age: 10, user: user_2)
				user_3 = create(:user)
				create(:child, age: 15, user: user_3)

				expect(User.find_child_by_age_range(min: 10, max: "")).to include(user_2, user_3)
				expect(User.find_child_by_age_range(min: 10, max: "")).to_not include(user_1)
			end
		end

		context "when only max is given" do
			it "returns all users under max" do
				user_1 = create(:user)
				create(:child, age: 1, user: user_1)
				user_2 = create(:user)
				create(:child, age: 10, user: user_2)
				user_3 = create(:user)
				create(:child, age: 15, user: user_3)

				expect(User.find_child_by_age_range(min: "", max: 10)).to include(user_1, user_2)
				expect(User.find_child_by_age_range(min: "", max: 10)).to_not include(user_3)
			end
		end
	end

	describe "hash_id" do
		context "when user is created" do
			it "sets a hash_id" do
				user = build(:user, hash_id: nil)

				user.save
				user.reload

				expect(user.hash_id).to_not be(nil)
			end
		end
	end

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

	describe "#liked?" do
		context "when user has already liked the post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				create(:emotion, post: post, user: user, emotion: "like")

				expect(user.liked?(post)).to eq(true)
			end
		end

		context "when user has not liked the post yet" do
			it "returns false" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				expect(user.liked?(post)).to eq(false)
			end
		end
	end

	describe "#sadded?" do
		context "when user has already sadded the post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				create(:emotion, post: post, user: user, emotion: "sad")

				expect(user.sadded?(post)).to eq(true)
			end
		end

		context "when user has not sadded the post yet" do
			it "returns false" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				expect(user.sadded?(post)).to eq(false)
			end
		end
	end

	describe "#happied?" do
		context "when user has already happied the post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				create(:emotion, post: post, user: user, emotion: "happy")

				expect(user.happied?(post)).to eq(true)
			end
		end

		context "when user has not happied the post yet" do
			it "returns false" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				expect(user.happied?(post)).to eq(false)
			end
		end
	end

	describe "#madded?" do
		context "when user has already madded the post" do
			it "returns true" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				create(:emotion, post: post, user: user, emotion: "mad")

				expect(user.madded?(post)).to eq(true)
			end
		end

		context "when user has not madded the post yet" do
			it "returns false" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				expect(user.madded?(post)).to eq(false)
			end
		end
	end

	describe "#like" do
		context "when user has already liked the post" do
			it "deletes the like" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				create(:emotion, post: post, user: user, emotion: "like")

				expect{
					user.like(post)
				}.to change(Emotion, :count).by(-1)
			end
		end

		context "when user has already emotioned the post with another emotion" do
			it "updates the emotion" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				emotion = create(:emotion, post: post, user: user, emotion: "mad")

				user.like(post)
				emotion.reload
				
				expect(emotion.emotion).to eq("like")
			end

			it "decrements the previous emotion count" do
				user = create(:user)
				post = create(:post, user_id: user.id, mads_count: 0)
				emotion = create(:emotion, post: post, user: user, emotion: "mad")
				
				expect{
					user.like(post)
				}.to change(post, :mads_count).by(-1)
			end
		end

		context "when user has not liked the post yet" do
			it "creates a new like" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				expect{
					user.like(post)
				}.to change(Emotion, :count).by(1)
			end
		end
	end

	describe "#sad" do
		context "when user has already sadded the post" do
			it "deletes the sad" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				create(:emotion, post: post, user: user, emotion: "sad")

				expect{
					user.sad(post)
				}.to change(Emotion, :count).by(-1)
			end
		end

		context "when user has already emotioned the post with another emotion" do
			it "updates the emotion" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				emotion = create(:emotion, post: post, user: user, emotion: "mad")

				user.sad(post)
				emotion.reload
				
				expect(emotion.emotion).to eq("sad")
			end

			it "decrements the previous emotion count" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				emotion = create(:emotion, post: post, user: user, emotion: "mad")
				
				expect{
					user.sad(post)
				}.to change(post, :mads_count).by(-1)
			end
		end

		context "when user has not liked the post yet" do
			it "creates a new sad" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				expect{
					user.sad(post)
				}.to change(Emotion, :count).by(1)
			end
		end
	end

	describe "#mad" do
		context "when user has already madded the post" do
			it "deletes the mad" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				create(:emotion, post: post, user: user, emotion: "mad")

				expect{
					user.mad(post)
				}.to change(Emotion, :count).by(-1)
			end
		end

		context "when user has already emotioned the post with another emotion" do
			it "updates the emotion" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				emotion = create(:emotion, post: post, user: user, emotion: "like")

				user.mad(post)
				emotion.reload
				
				expect(emotion.emotion).to eq("mad")
			end

			it "decrements the previous emotion count" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				emotion = create(:emotion, post: post, user: user, emotion: "like")
				
				expect{
					user.mad(post)
				}.to change(post, :likes_count).by(-1)
			end
		end

		context "when user has not madded the post yet" do
			it "creates a new mad" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				expect{
					user.mad(post)
				}.to change(Emotion, :count).by(1)
			end
		end
	end

	describe "#happy" do
		context "when user has already happied the post" do
			it "deletes the happy" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				create(:emotion, post: post, user: user, emotion: "happy")

				expect{
					user.happy(post)
				}.to change(Emotion, :count).by(-1)
			end
		end

		context "when user has already emotioned the post with another emotion" do
			it "updates the emotion" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				emotion = create(:emotion, post: post, user: user, emotion: "mad")

				user.happy(post)
				emotion.reload
				
				expect(emotion.emotion).to eq("happy")
			end

			it "decrements the previous emotion count" do
				user = create(:user)
				post = create(:post, user_id: user.id)
				emotion = create(:emotion, post: post, user: user, emotion: "mad")
				
				expect{
					user.happy(post)
				}.to change(post, :mads_count).by(-1)
			end
		end

		context "when user has not happied the post yet" do
			it "creates a new happy" do
				user = create(:user)
				post = create(:post, user_id: user.id)

				expect{
					user.happy(post)
				}.to change(Emotion, :count).by(1)
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

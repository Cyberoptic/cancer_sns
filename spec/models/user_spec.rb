require 'rails_helper'

RSpec.describe User, type: :model do
	describe "#has_moderator_rights_for?" do
		context "user is the owner of the group" do
			it "returns true" do
				user = create(:user)
				group = create(:group, owner: user)

				expect(user.has_moderator_rights_for?(group)).to eq(true)
			end
		end

		context "user is a moderator of the group" do
			it "returns true" do
				user = create(:user)
				group = create(:group)
				create(:group_membership, group: group, user: user, role: :moderator)

				expect(user.has_moderator_rights_for?(group)).to eq(true)
			end
		end

		context "user is neither a moderator or owner of the group" do
			it "returns false" do
				user = create(:user)
				group = create(:group)

				expect(user.has_moderator_rights_for?(group)).to eq(false)
			end
		end
	end

	describe "#has_not_joined_group" do
		it "returns users that have not joined the group" do
			user = create(:user)
			user_2 = create(:user)
			user_3 = create(:user)
			group = create(:group)
			create(:group_membership, user: user, group: group)

			expect(User.has_not_joined_group(group)).to include(user_3)
		end
	end
	
	describe "#joined?" do
		context "when the user has joined the group" do
			it "returns true" do
				user = create(:user)
				group = create(:group)
				create(:group_membership, user: user, group: group, status: :accepted)

				expect(user.joined?(group)).to eq(true)
			end
		end

		context "when the user has not joined the group" do
			it "returns false" do
				user = create(:user)
				group = create(:group)				

				expect(user.joined?(group)).to eq(false)
			end
		end

		context "when the user has a pending group membership" do
			it "returns false" do
				user = create(:user)
				group = create(:group)
				create(:group_membership, user: user, group: group, status: :pending)

				expect(user.joined?(group)).to eq(false)
			end
		end
	end

	describe "#attribute_is_public" do
		context "when argument is name_visiblity" do
			it "returns a collection of users where the name visibility is public" do
				user_1 = create(:user, settings: {name_visibility: User::SETTING_OPTIONS.first})
				user_2 = create(:user, settings: {name_visibility: User::SETTING_OPTIONS.first})
				user_3 = create(:user, nickname: "Nickname", settings: {name_visibility: User::SETTING_OPTIONS.last})

				expect(User.attribute_is_public("name_visibility")).to include(user_1, user_2)
				expect(User.attribute_is_public("name_visibility")).to_not include(user_3)
			end
		end

		context "when argument is profession_visiblity" do
			it "returns a collection of users where the name visibility is public" do
				user_1 = create(:user, settings: {profession_visibility: User::SETTING_OPTIONS.first})
				user_2 = create(:user, settings: {profession_visibility: User::SETTING_OPTIONS.first})
				user_3 = create(:user, settings: {profession_visibility: User::SETTING_OPTIONS.last})

				expect(User.attribute_is_public("profession_visibility")).to include(user_1, user_2)
				expect(User.attribute_is_public("profession_visibility")).to_not include(user_3)
			end
		end
	end

	describe "after_update" do
		context "when user is created" do
			it "updates the name" do
				user = build(:user, first_name: "John", last_name: "Doe")

				user.save
				user.reload

				expect(user.name).to eq("DoeJohn")
			end
		end

		context "when user is updated" do
			it "updates the name" do
				user = create(:user, first_name: "John", last_name: "Doe")

				user.update(first_name: "Mark", last_name: "Zuckerburg")
				user.reload

				expect(user.name).to eq("ZuckerburgMark")
			end
		end
	end

	describe "#name_search" do
		context "when name_visibility is set to false" do
			it "returns users where the nickname is equal to the argument" do
				user_1 = create(:user, nickname: "たろう")
				user_2 = create(:user, nickname: "タナカ")
				user_1.update(settings: {name_visibility: "非公開"})
				user_2.update(settings: {name_visibility: "非公開"})

				expect(User.name_search("タナカ").pluck(:id)).to include(user_2.id) 
				expect(User.name_search("タナカ").pluck(:id)).to_not include(user_1.id)
				expect(User.name_search("たろう").pluck(:id)).to include(user_1.id)
				expect(User.name_search("たろう").pluck(:id)).to_not include(user_2.id)
			end
		end

		it "returns users where the name is equal to argument" do
			user_1 = create(:user, name: "DoeJohn", first_name: "John", last_name: "Doe")
			user_2 = create(:user, name: "ConnerMike", first_name: "Mike", last_name: "Conner")

			expect(User.name_search("DoeJ")).to include(user_1)
			expect(User.name_search("DoeJ")).to_not include(user_2)
		end

		it "returns users where the first name is equal to argument" do
			user_1 = create(:user, first_name: "John")
			user_2 = create(:user, first_name: "Mike")

			expect(User.name_search("John")).to include(user_1)
			expect(User.name_search("John")).to_not include(user_2)
		end

		it "returns users where the last name is equal to argument" do
			user_1 = create(:user, last_name: "Doe")
			user_2 = create(:user, last_name: "Zuckerburg")

			expect(User.name_search("Zuckerburg")).to include(user_2)
			expect(User.name_search("Zuckerburg")).to_not include(user_1)
		end

		it "returns users where the nickname is equal to argument" do
			user_1 = create(:user, nickname: "Doe")
			user_2 = create(:user, nickname: "Zuckerburg")

			expect(User.name_search("Zuckerburg")).to include(user_2)
			expect(User.name_search("Zuckerburg")).to_not include(user_1)
		end

		it "returns users where the last_name_katakana is equal to argument" do
			user_1 = create(:user, last_name_katakana: "山本")
			user_2 = create(:user, last_name_katakana: "田中")

			expect(User.name_search("田中")).to include(user_2)
			expect(User.name_search("田中")).to_not include(user_1)
		end

		it "returns users where the first_name_katakana is equal to argument" do
			user_1 = create(:user, first_name_katakana: "山本")
			user_2 = create(:user, first_name_katakana: "田中")

			expect(User.name_search("田中")).to include(user_2)
			expect(User.name_search("田中")).to_not include(user_1)
		end
	end

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

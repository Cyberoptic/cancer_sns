require 'rails_helper'

RSpec.describe GroupPost, type: :model do
  describe "#has_likes?" do
    context "when post has a like" do
      it "returns true" do
        group = create(:group)
        user = create(:user)
        post = create(:group_post, user_id: user.id, group: group)
        create(:emotion, post: post, emotion: "like", user_id: user.id)

        expect(post.has_likes?).to eq(true)
      end
    end

    context "when post doesn't have a like" do
      it "returns false" do
        group = create(:group)
        user = create(:user)
        post = create(:group_post, user_id: user.id, group: group)

        expect(post.has_likes?).to eq(false)
      end
    end
  end

  describe "#has_sads?" do
    context "when post has a sad" do
      it "returns true" do
        group = create(:group)
        user = create(:user)
        post = create(:group_post, user_id: user.id, group: group)
        create(:emotion, post: post, emotion: "sad", user_id: user.id)

        expect(post.has_sads?).to eq(true)
      end
    end

    context "when post doesn't have a sad" do
      it "returns false" do
        group = create(:group)
        user = create(:user)
        post = create(:group_post, user_id: user.id, group: group)

        expect(post.has_sads?).to eq(false)
      end
    end
  end

  describe "#has_happies?" do
    context "when post has a happy" do
      it "returns true" do
        group = create(:group)
        user = create(:user)
        post = create(:group_post, user_id: user.id, group: group)
        create(:emotion, post: post, emotion: "happy", user_id: user.id)

        expect(post.has_happies?).to eq(true)
      end
    end

    context "when post doesn't have a happy" do
      it "returns false" do
        group = create(:group)
        user = create(:user)
        post = create(:group_post, user_id: user.id, group: group)

        expect(post.has_happies?).to eq(false)
      end
    end
  end

  describe "#has_mads?" do
    context "when post has a mad" do
      it "returns true" do
        group = create(:group)
        user = create(:user)
        post = create(:group_post, user_id: user.id, group: group)
        create(:emotion, post: post, emotion: "mad", user_id: user.id)

        expect(post.has_mads?).to eq(true)
      end
    end

    context "when post doesn't have a mad" do
      it "returns false" do
        group = create(:group)
        user = create(:user)
        post = create(:group_post, user_id: user.id, group: group)

        expect(post.has_mads?).to eq(false)
      end
    end
  end
end

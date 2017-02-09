require 'rails_helper'

RSpec.describe Emotion, type: :model do
  describe "after_create" do
    context "when user that created the post emotioned is the same user as the user emotioned" do
      it "does not create any notifications" do
        user = create(:user)
        post = create(:post, user: user)

        expect {
          create(:emotion, emotion: :like, user: user, post: post)
        }.to change(Notification, :count).by(0)
      end
    end

    context "when user that created the post emotioned is not the same user as the user emotioned" do
      it "creates notifications" do
        user = create(:user)
        user_2 = create(:user)
        post = create(:post, user: user)

        expect {
          create(:emotion, emotion: :like, user: user_2, post: post)
        }.to change(Notification, :count).by(1)
      end  
    end

    context "when emotion is like" do
      it "increments the product's emotion count" do
        user = create(:user)
        post = create(:post, user: user, likes_count: 0)

        create(:emotion, user: user, post: post, emotion: :like)
        post.reload

        expect(post.likes_count).to be(1)
      end
    end
    

    context "when emotion is sad" do
      it "increments the product's emotion count" do
        user = create(:user)
        post = create(:post, user: user, sads_count: 0)

        create(:emotion, user: user, post: post, emotion: :sad)
        post.reload

        expect(post.sads_count).to be(1)
      end
    end

    context "when emotion is mad" do
      it "increments the product's emotion count" do
        user = create(:user)
        post = create(:post, user: user, mads_count: 0)

        create(:emotion, user: user, post: post, emotion: :mad)
        post.reload

        expect(post.mads_count).to be(1)
      end
    end

    context "when emotion is happy" do
      it "increments the product's emotion count" do
        user = create(:user)
        post = create(:post, user: user, happies_count: 0)

        create(:emotion, user: user, post: post, emotion: :happy)
        post.reload

        expect(post.happies_count).to be(1)
      end
    end
  end
end

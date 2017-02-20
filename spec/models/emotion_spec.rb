require 'rails_helper'

RSpec.describe Emotion, type: :model do
  describe "uniqueness" do
    context "when there is already an emotion for the post by a given user" do
      it "is not valid" do
        user = create(:user)
        post = create(:post, user: user)
        create(:emotion, post: post, emotion: "like", user: user)

        emotion = build(:emotion, post: post, emotion: "happy", user: user)

        expect(emotion).to_not be_valid
      end
    end

    context "when there is not an emotion for the post by a given user" do
      it "is valid" do
        user = create(:user)
        post = create(:post, user: user)

        emotion = build(:emotion, post: post, emotion: "happy", user: user)

        expect(emotion).to be_valid
      end
    end

    context "when there is an emotion for the post_id but a different post_type by a given user" do
      it "is valid" do
        user = create(:user)
        post = create(:post, user: user)
        group = create(:group)
        group_post = create(:group_post, group: group, user: user, id: post.id)
        create(:emotion, post: group_post, emotion: "like", user: user)

        emotion = build(:emotion, post: post, emotion: "happy", user: user)

        expect(emotion).to be_valid
      end
    end
  end

  describe "after_create" do
    describe "#increment_counter!" do
      context "when emotion is like" do
        it "increments the post's likes_count" do
          user = create(:user)
          post = create(:post, user: user)

          expect{
            create(:emotion, post: post, emotion: "like")
          }.to change(post, :likes_count).by(1)
        end
      end

      context "when emotion is mad" do
        it "increments the post's mads_count" do
          user = create(:user)
          post = create(:post, user: user)

          expect{
            create(:emotion, post: post, emotion: "mad")
          }.to change(post, :mads_count).by(1)
        end
      end

      context "when emotion is sad" do
        it "increments the post's sads_count" do
          user = create(:user)
          post = create(:post, user: user)

          expect{
            create(:emotion, post: post, emotion: "sad")
          }.to change(post, :sads_count).by(1)
        end
      end

      context "when emotion is happy" do
        it "increments the post's happies_count" do
          user = create(:user)
          post = create(:post, user: user)

          expect{
            create(:emotion, post: post, emotion: "happy")
          }.to change(post, :happies_count).by(1)
        end
      end
    end

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

  describe "after_destroy" do
    describe "#decrement_counter!" do
      context "when emotion is like" do
        it "decrements the post's likes_count" do
          user = create(:user)
          post = create(:post, user: user)
          emotion = create(:emotion, post: post, emotion: "like")

          expect{
            emotion.destroy
          }.to change(post, :likes_count).by(-1)
        end
      end

      context "when emotion is mad" do
        it "decrements the post's mads_count" do
          user = create(:user)
          post = create(:post, user: user)
          emotion = create(:emotion, post: post, emotion: "mad")

          expect{
            emotion.destroy
          }.to change(post, :mads_count).by(-1)
        end
      end

      context "when emotion is sad" do
        it "decrements the post's sads_count" do
          user = create(:user)
          post = create(:post, user: user)
          emotion = create(:emotion, post: post, emotion: "sad")

          expect{
            emotion.destroy
          }.to change(post, :sads_count).by(-1)
        end
      end

      context "when emotion is happy" do
        it "decrements the post's happies_count" do
          user = create(:user)
          post = create(:post, user: user)
          emotion = create(:emotion, post: post, emotion: "happy")

          expect {
            emotion.destroy
          }.to change(post, :happies_count).by(-1)
        end
      end
    end
  end

  describe "around_update" do
    context "when emotion is updated from like to happy" do
      it "increments the happies_count" do
        user = create(:user)
        post = create(:post, user: user, likes_count: 0, happies_count: 0)
        emotion = create(:emotion, post: post, emotion: "like") # increments likes_count by 1

        emotion.update(emotion: "happy")
        post.reload
        
        expect(post.happies_count).to eq(1)
      end
    end
  end
end

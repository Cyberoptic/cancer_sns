require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "after_create" do
    it "creates notifications for all users involved in the parent post" do
      user = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)
      post = create(:post, user: user)
      comment = create(:comment, visible: true, post: post, user_id: user_2.id)

      expect {
        create(:comment, visible: true, post: post, user_id: user_3.id)
      }.to change(Notification, :count).by(2)
    end
  end

  describe "#toggle_visibility!" do
    context "when visible is true" do
      it "toggles visibility to false" do
        user = create(:user)
        post = create(:post, user_id: user.id)
        comment = create(:comment, visible: true, post_id: post.id, post_type: post.class.name, user_id: user.id)

        comment.toggle_visibility!
        comment.reload

        expect(comment.visible).to eq(false)
      end
    end

    context "when visible is false" do
      it "toggles visibility to true" do
        user = create(:user)
        post = create(:post, user_id: user.id)
        comment = create(:comment, visible: false, post_id: post.id, post_type: post.class.name, user_id: user.id)

        comment.toggle_visibility!
        comment.reload

        expect(comment.visible).to eq(true)
      end
    end
  end

  describe "#delete!" do
    it "soft deletes the comment" do
      user = create(:user)
      post = create(:post, user_id: user.id)
      comment = create(:comment, visible: false, post_id: post.id, post_type: post.class.name, user_id: user.id, deleted_at: nil)

      comment.delete!

      expect(comment.deleted_at).to_not be_nil
    end
  end

  describe "#deleted?" do
    context "comment is deleted" do
      it "returns true" do
        user = create(:user)
        post = create(:post, user_id: user.id)
        comment = create(:comment, visible: false, post_id: post.id, post_type: post.class.name, user_id: user.id, deleted_at: DateTime.now)

        expect(comment.deleted?).to eq(true)
      end
    end

    context "comment is not deleted" do
      it "returns false" do
        user = create(:user)
        post = create(:post, user_id: user.id)
        comment = create(:comment, visible: false, post_id: post.id, post_type: post.class.name, user_id: user.id, deleted_at: nil)

        expect(comment.deleted?).to eq(false)
      end
    end
  end
end

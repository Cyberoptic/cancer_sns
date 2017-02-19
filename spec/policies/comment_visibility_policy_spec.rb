require 'rails_helper'

RSpec.describe CommentVisibilityPolicy do

  describe "#visibility" do
    context "when comment is visible and user is not the owner of the post or the comment" do
      it "returns true" do
        user = create(:user)
        post = create(:post, user: create(:user))
        comment = create(:comment, post: post, visible: true, user: create(:user))

        expect(CommentVisibilityPolicy.new(current_user: user, comment: comment).visible?).to eq(true)
      end
    end

    context "when comment is not visible and user is not the owner of the post or the comment" do
      it "returns false" do
        user = create(:user)
        post = create(:post, user: create(:user))
        comment = create(:comment, post: post, visible: false, user: create(:user))

        expect(CommentVisibilityPolicy.new(current_user: user, comment: comment).visible?).to eq(false)
      end
    end

    context "when comment's owner is current_user and the comment is not visible" do
      it "returns true" do
        user = create(:user)
        post = create(:post, user: create(:user))
        comment = create(:comment, post: post, visible: false, user: user)

        expect(CommentVisibilityPolicy.new(current_user: user, comment: comment).visible?).to eq(true)
      end
    end

    context "when comment's owner is not current_user and the comment is not visible" do
      it "returns false" do
        user = create(:user)
        post = create(:post, user: create(:user))
        comment = create(:comment, post: post, visible: false, user: create(:user))

        expect(CommentVisibilityPolicy.new(current_user: user, comment: comment).visible?).to eq(false)
      end
    end

    context "when the owner of the post being commented on is current_user" do
      it "returns true" do
        user = create(:user)
        post = create(:post, user: user)
        comment = create(:comment, post: post, visible: false, user: create(:user))

        expect(CommentVisibilityPolicy.new(current_user: user, comment: comment).visible?).to eq(true)
      end
    end

    context "when the owner of the post being commented on is not current_user" do
      it "returns false" do
        user = create(:user)
        post = create(:post, user: create(:user))
        comment = create(:comment, post: post, visible: false, user: create(:user))

        expect(CommentVisibilityPolicy.new(current_user: user, comment: comment).visible?).to eq(false)
      end
    end
  end

end

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "#toggle_visibility!" do
    context "when visible is true" do
      it "toggles visibility to false" do
        user = create(:user)
        post = create(:post, user_id: user.id)
        comment = create(:comment, visible: true, post_id: post.id, user_id: user.id)

        comment.toggle_visibility!
        comment.reload

        expect(comment.visible).to eq(false)
      end
    end

    context "when visible is false" do
      it "toggles visibility to true" do
        user = create(:user)
        post = create(:post, user_id: user.id)
        comment = create(:comment, visible: false, post_id: post.id, user_id: user.id)

        comment.toggle_visibility!
        comment.reload

        expect(comment.visible).to eq(true)
      end
    end
  end
end

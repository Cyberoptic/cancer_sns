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
    
  end
end

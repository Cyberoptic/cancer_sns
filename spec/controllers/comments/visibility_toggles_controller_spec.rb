require 'rails_helper'

RSpec.describe Comments::VisibilityTogglesController, type: :controller do
  describe "POST #create" do
    render_views false

    it "sends the toggle_visibility! method" do
      user = create(:user)
      comment = double(:comment, id: 1)      
      allow(Comment).to receive(:find).and_return(comment)
      allow(comment).to receive(:toggle_visibility!)
      allow(comment).to receive(:reload)

      sign_in user
      post :create, comment_id: comment.id, format: :js

      expect(Comment).to have_received(:find)
      expect(comment).to have_received(:toggle_visibility!)
      expect(comment).to have_received(:reload)
    end
  end
end

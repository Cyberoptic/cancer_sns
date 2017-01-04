require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

describe 'POST #create' do
	context 'with valid attributes' do
	   	it "should create  new comment" do
        	user = create(:user)
          sign_in user
          user_post = create(:post, user_id: user.id)

          post :create, post_id: user_post.id , comment: attributes_for(:comment), format: :js

          expect(Comment.count).to eq 1 
      	 end
    end
    context 'with invalid attributes' do
     	it 'should not create a new comment' do
		    user = create(:user)
		    sign_in user
		    user_post = create(:post, user_id: user.id)

        post :create, post_id: user_post.id , comment: attributes_for(:comment, text: nil), format: :js

        expect(Comment.count).to eq 0
      	end
    end
end	

end

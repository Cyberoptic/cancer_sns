require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#Create new session" do
    it 'signins new user' do
      user = FactoryGirl.create(:user)
      sign_in user
      expect(controller.current_user).not_to equal(nil)
    end
  end
end

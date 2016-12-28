require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe '#create user ' do
    it 'creates new user ' do
      expect {post :create, user: FactoryGirl.attributes_for(:user)}.to change(User,:count).by(1)
    end
  end

end

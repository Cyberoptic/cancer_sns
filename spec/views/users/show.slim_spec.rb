require 'rails_helper'

RSpec.describe "users/show.slim", type: :view do
  context "when user's name_visibility is set to private" do
    it "does not display the name" do
      def view.unread_messages
        Message.all
      end
      user = create(:user, first_name: "John", last_name: "Doe", name: "DoeJohn", nickname: "John's nickname", settings: {name_visibility: User::SETTING_OPTIONS.last}).decorate
      current_user = create(:user)
      assign(:user, user)      

      sign_in create(:user)
      render

      expect(rendered).to_not include("DoeJohn")      
    end    
  end

  context "when user's name_visibility is set to public" do
    it "displays the name" do
      def view.unread_messages
        Message.all
      end
      user = create(:user, first_name: "John", last_name: "Doe", name: "DoeJohn", settings: {name_visibility: User::SETTING_OPTIONS.first}).decorate
      current_user = create(:user)
      assign(:user, user)      

      sign_in create(:user)
      render

      expect(rendered).to include("DoeJohn")
    end
  end  
end

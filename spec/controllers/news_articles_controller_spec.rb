require 'rails_helper'

RSpec.describe NewsArticlesController, type: :controller do
  describe "GET #index" do
    context "when user is not logged in" do
      it "redirects the user" do
        get :index

        expect(response).to redirect_to new_user_session_path
      end
    end

    it "renders the index template" do
      user = create(:user)

      sign_in user
      get :index

      expect(response).to render_template :index
    end

    it "returns 200" do
      user = create(:user)

      sign_in user
      get :index

      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    context "when user is not logged in" do
      it "redirects the user" do
        get :index

        expect(response).to redirect_to new_user_session_path
      end
    end
    
    it "renders the show template" do
      article = create(:news_article)
      user = create(:user)

      sign_in user
      get :show, params: {id: article.id}

      expect(response).to render_template :show
    end

    it "returns 200" do
      article = create(:news_article)
      user = create(:user)

      sign_in user
      get :show, params: {id: article.id}

      expect(response.status).to eq(200)
    end
  end
end

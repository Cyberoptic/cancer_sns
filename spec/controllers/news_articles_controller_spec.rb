require 'rails_helper'

RSpec.describe NewsArticlesController, type: :controller do
  describe "GET #index" do
    it "renders the index template" do
      get :index

      expect(response).to render_template :index
    end

    it "returns 200" do
      get :index

      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      article = create(:news_article)

      get :show, params: {id: article.id}

      expect(response).to render_template :show
    end

    it "returns 200" do
      article = create(:news_article)

      get :show, params: {id: article.id}

      expect(response.status).to eq(200)
    end
  end
end

class NewsArticlesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @news_articles = NewsArticle.all
  end

  def show
    @news_article = NewsArticle.find(params[:id])  
  end
end

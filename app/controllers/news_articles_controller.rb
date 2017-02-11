class NewsArticlesController < ApplicationController
  def index
    @news_articles = NewsArticle.all
    @unread_messages = Message.unread_by(current_user).includes(chat_room: [:user, :member, :messages])
    @unread_group_posts =  GroupPost.unread_by(current_user).includes(:user, :group)
  end

  def show
    @news_article = NewsArticle.find(params[:id])
    @unread_messages = Message.unread_by(current_user).includes(chat_room: [:user, :member, :messages])
    @unread_group_posts =  GroupPost.unread_by(current_user).includes(:user, :group)
  end
end

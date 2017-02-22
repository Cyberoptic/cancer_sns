class AddPhotoToNewsArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :news_articles, :photo, :string
  end
end

class Posts::TagsController < ApplicationController
  def index
    if params[:tag]
      @posts = Post.visible_for(current_user).tagged_with(params[:tag]).reorder(updated_at: :desc).paginate(page: params[:page], per_page: 3)
    else
      @posts = Post.visible_for(current_user).reorder(updated_at: :desc).paginate(page: params[:page], per_page: 3)
    end
  end
end

class PostTagsController < ApplicationController
  def index
    @tags = PostTag.all
  end
end

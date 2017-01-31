class StaticController < ApplicationController
  def home
    render layout: 'landing_page'
  end
end

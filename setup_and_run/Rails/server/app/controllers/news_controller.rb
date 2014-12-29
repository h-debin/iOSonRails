class NewsController < ApplicationController
  def index
    render :json => News.all
  end
end

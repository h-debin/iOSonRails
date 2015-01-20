module Api
  module V1
    class NewsController < ApplicationController
      def index
        all_news = News.all
        if stale?(etag: all_news)
          render :json => all_news
        end
      end

      def show
        news = News.find_by(id: params[:id])
        if stale?(etag: news)
          render :json => news
        end
      end
    end
  end
end

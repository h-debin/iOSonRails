module Api
  module V1
    class NewsController < ApplicationController
      def index
        all_news = News.all
        if stale?(etag: all_news)
          render :json => News.all 
        end
      end

      def show
        news = News.find_by(id: params[:id])
        puts "_____"
        puts request.headers[:UUID]
        puts request.headers[:Token]
        puts "_____"
        if stale?(etag: news)
          render :json => News.find_by(id: params[:id])
        end
      end
    end
  end
end

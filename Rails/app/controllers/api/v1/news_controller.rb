module Api
  module V1
    class NewsController < ApplicationController
      def index
        #expires_in 4032.minutes, :public => true

        #all_news = News.all
        #if stale?(etag: all_news)
        #  render :json => all_news
        #end

        emotion_type = params["emotion_type"]
        news_list = get_news_by(emotion_type:emotion_type)
        render :json => news_list
      end

      def show
        expires_in 4032.minutes, :public => true

        news = News.find_by(id: params[:id])
        if stale?(etag: news)
          render :json => news
        end
      end

      private
      def get_news_by(emotion_type:)
        news = News.where(emotion_type: emotion_type).order("main_emotion_value DESC")
      end
    end
  end
end

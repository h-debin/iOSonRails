module Api
  module V1
    class NewsController < ApplicationController
      def index
        render :json => News.all
      end
    end
  end
end

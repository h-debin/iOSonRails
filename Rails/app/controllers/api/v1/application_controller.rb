module Api
  module V1
    class ApplicationController < ActionController::Base
      # Prevent CSRF attacks by raising an exception.
      # For APIs, you may want to use :null_session instead.
      protect_from_forgery with: :null_session

      #before_action :require_token_authentication

      private
      def require_token_authentication
        unless token_autentication
          flash[:error] = "Please use a valid token to access"
          render :status => 511, :json => { status: "require token to access" }
        end
      end

      def token_autentication
        device_uuid = request.headers[:UUID]
        token = request.headers[:Token]

        # ++
        #logger.warn "*** BEGIN RAW REQUEST HEADERS ***"
        #self.request.env.each do |header|
        #    logger.warn "HEADER KEY: #{header[0]}"
        #      logger.warn "HEADER VAL: #{header[1]}"
        #end
        #logger.warn "*** END RAW REQUEST HEADERS ***"
        # ++
        if User.find_by(device_uuid: device_uuid,  token: token)
          return true
        end
        return false
      end
    end
  end
end

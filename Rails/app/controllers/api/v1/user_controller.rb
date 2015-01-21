module Api
  module V1
    class UserController < ApplicationController
      # ++
      # skip token check when user request a token
      # ++
      skip_before_action :require_token_authentication, :only => [:create]

      def create
        uuid = params[:uuid]
        token = Digest::MD5.hexdigest uuid
        if User.create(device_uuid: uuid, token: token)
          render :json => { token: token } 
          return
        end

        render :json => "token already taken, please use your token to access", :status => 511
      end
    end
  end
end

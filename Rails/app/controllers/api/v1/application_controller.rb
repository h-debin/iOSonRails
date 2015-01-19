class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  before_action :require_token_authentication

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
    if User.find_by(device_uuid: device_uuid,  token: token)
      return true
    end
    return false
  end
end

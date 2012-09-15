class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  #before_filter :redirect_www_to_root

  private

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def redirect_www_to_root
  	host = request.host.gsub(/www./,”)

    if /^www/.match(request.host) 
    	new_url = "#{request.protocol}#{host}#{request.request_uri}" 
    	redirect_to(new_url, :status => 301) 
    end
end

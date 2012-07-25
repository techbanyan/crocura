class SessionsController < ApplicationController

	def create
		auth = request.env["omniauth.auth"]
		user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
		session[:user_id] = user.id
		redirect_to root_url
		flash[:success] = "Welcome! #{auth["info"]["name"]}"
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_url
		flash[:success] = "Bye!"
	end

	def oauth_failure
		redirect_to root_url
		flash[:error] = "You need to authorize Crocura to access your Instagram profile!"
	end
end
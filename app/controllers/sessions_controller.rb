class SessionsController < ApplicationController

	def create
		auth = request.env["omniauth.auth"]
		user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
		session[:user_id] = user.id
		session[:access_token] = auth["credentials"]["token"]
		current_user.user_stream_photos.destroy_all
		if session[:return_to].present?
			redirect_to session[:return_to]
			return
		else
			redirect_to root_url
		end
		flash[:success] = "Aloha, #{auth["info"]["nickname"]}"
	end

	def destroy
		current_user.user_stream_photos.destroy_all
		session[:user_id] = nil
		session[:access_token] = nil
		session[:return_to] = nil
		redirect_to root_url
		flash[:success] = "Bye!"
	end

	def oauth_failure
		redirect_to root_url
		flash[:error] = "You need to authorize Crocura to access your Instagram profile!"
	end
end
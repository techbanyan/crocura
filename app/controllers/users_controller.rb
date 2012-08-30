require 'facets/enumerable/each_by'
class UsersController < ApplicationController
	respond_to :html, :xml, :json
	before_filter :check_if_signed_in, :only => [:follow_user, :unfollow_user]

	def index
		flash[:error] = "Sorry! You are not authorized to view the page"
		redirect_to root_url
		return
	end

	def show
		@show_more_data = false
		users_stream_container
	end

	def users_stream_container
		if @show_more_data == false
			@show_more_data = true
			@user_array = Instagram.user_search(params[:id], :count => 1)
			@username = params[:id]
			if @user_array.data.present?
				if @user_array.data.first.username == params[:id]			
					user_id = @user_array.data.first.id
					@user = Instagram.user(user_id)
					if current_user
						@user_relationship = Instagram.user_relationship(user_id, :access_token => session[:access_token])
						media_packet = Instagram.user_recent_media(user_id, :access_token => session[:access_token])
						@next_max_id = media_packet.pagination.next_max_id
						Rails.cache.write('next_max_id', @next_max_id)
						@media = media_packet.data

					end
				else
					flash[:error] = "User #{params[:id]} is not found"
					redirect_to root_url
				end
			else
				flash[:error] = "User #{params[:id]} is not found"
				redirect_to root_url
			end
		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		            	render :partial => "users/users_stream_container", :locals => { :media => @media, :username => params[:id], :layout => false, :status => :created}
		        	end
		    	end
		    end
		    return
		else
			@user_array = Instagram.user_search(params[:username], :count => 1)
			@username = params[:username]
			if @user_array.data.present?
				if @user_array.data.first.username == params[:username]			
					user_id = @user_array.data.first.id
					@user = Instagram.user(user_id)
					if current_user
						@user_relationship = Instagram.user_relationship(user_id, :access_token => session[:access_token])
						@next_max_id ||= Rails.cache.fetch('next_max_id')
						media_packet = Instagram.user_recent_media(user_id, :max_id => @next_max_id, :access_token => session[:access_token])
						@media = media_packet.data
						@next_max_id = media_packet.pagination.next_max_id
						Rails.cache.write('next_max_id', @next_max_id)
					end
				else
					flash[:error] = "User #{params[:id]} is not found"
					redirect_to root_url
				end
			else
				flash[:error] = "User #{params[:id]} is not found"
				redirect_to root_url
			end
		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		            	render :partial => "users/stream", :locals => { :media => @media, :username => params[:username], :layout => false, :status => :created}
		        	end
		    	end
		    end
		    return
		end
	end

	def unfollow_user
		Instagram.unfollow_user(params[:user_id], :access_token => session[:access_token])
		redirect_to user_path(params[:username])
	end

	def follow_user
		Instagram.follow_user(params[:user_id], :access_token => session[:access_token])
		redirect_to user_path(params[:username])
	end

	protected

	def check_if_signed_in
		if !current_user
			flash[:error] = "You are not authorized to view this page!"
			redirect_to root_url
		end
	end
end

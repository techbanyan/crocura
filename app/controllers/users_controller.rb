require 'facets/enumerable/each_by'
class UsersController < ApplicationController
	respond_to :html, :xml, :json
	before_filter :check_if_signed_in, :only => [:follow_user, :unfollow_user]
	before_filter :check_if_logged_in_user_is_private

	def index
		flash[:error] = "Sorry! You are not authorized to view the page"
		redirect_to root_url
		return
	end

	def show
		@show_more_data = false
		@show_more_bar = false
		users_stream_container
	end

	def users_stream_container
		@query = params[:query]
		if @show_more_data == false
			@show_more_data = true
			if @query.present?
				if @query == "followers"
					@user_id = params[:id]
					media_packet = @client.user_followed_by(@user_id, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_cursor = media_packet.pagination.next_cursor
						if @next_cursor.present?
							@show_more_bar = true
						else
							@show_more_bar = false
						end
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						flash[:error] = "User #{params[:id]} is not found"
						redirect_to root_url
					end
				elsif @query == "following"
					@user_id = params[:id]
					media_packet = @client.user_follows(@user_id, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_cursor = media_packet.pagination.next_cursor
						if @next_cursor.present?
							@show_more_bar = true
						else
							@show_more_bar = false
						end
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						flash[:error] = "User #{params[:id]} is not found"
						redirect_to root_url
					end
				end
			else
				@user_array = @client.user_search(params[:id], :count => 1)
				@username = params[:id]
				if @user_array.data.present?
					if @user_array.data.first.username == params[:id]			
						@user_id = @user_array.data.first.id
						begin 
							@user = @client.user(@user_id, :access_token => session[:access_token])
							if current_user
								if current_user.uid != @user_id
									@user_relationship = @client.user_relationship(@user_id, :access_token => session[:access_token])
								end
								media_packet = @client.user_recent_media(@user_id, :access_token => session[:access_token], :count => 18)
								@next_max_id = media_packet.pagination.next_max_id
								if @next_max_id.present?
									@show_more_bar = true
								else
									@show_more_bar = false
								end
								Rails.cache.write('next_max_id', @next_max_id)
								@media = media_packet.data
							end
						rescue
							flash[:error] = "Sorry, #{@user_array.data.first.username} is a private user"
							redirect_to root_url
						end
					else
						flash[:error] = "User #{params[:id]} is not found"
						redirect_to root_url
					end
				else
					flash[:error] = "User #{params[:id]} is not found"
					redirect_to root_url
				end
			end
		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		            	render :partial => "users/users_stream_container", :locals => { :show_more_bar => @show_more_bar, :media => @media, :user_id => @user_id, :username => params[:id], :layout => false, :status => :created}
		        	end
		    	end
		    end
		    return
		else
			if @query.present?
				if @query == "followers"
					@cursor = Rails.cache.fetch('next_cursor')
					if @cursor.present?
						media_packet = @client.user_followed_by(params[:id], :cursor => @cursor, :access_token => session[:access_token], :count => 28)
						if media_packet.data.present?
							@next_cursor = media_packet.pagination.next_cursor
							if @next_cursor.present?
								@show_more_bar = true
							else
								@show_more_bar = false
							end
							Rails.cache.write('next_cursor', @next_cursor)
							@media = media_packet.data
						else
							flash[:error] = "User #{params[:id]} is not found"
							redirect_to root_url
						end
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
					else
						@show_more_bar = true
					end					
				elsif @query == "following"
					@cursor = Rails.cache.fetch('next_cursor')
					if @cursor.present?
						media_packet = @client.user_follows(params[:id], :cursor => @cursor, :access_token => session[:access_token], :count => 28)
						if media_packet.data.present?
							@next_cursor = media_packet.pagination.next_cursor
							if @next_cursor.present?
								@show_more_bar = true
							else
								@show_more_bar = false
							end
							Rails.cache.write('next_cursor', @next_cursor)
							@media = media_packet.data
						else
							flash[:error] = "User #{params[:id]} is not found"
							redirect_to root_url
						end
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
					else
						@show_more_bar = true
					end
				end
			else		
				if current_user
					@next_max_id = Rails.cache.fetch('next_max_id')
					if @next_max_id.present?
						media_packet = @client.user_recent_media(params[:id], :max_id => @next_max_id, :access_token => session[:access_token], :count => 18)
						@media = media_packet.data
						@next_max_id = media_packet.pagination.next_max_id
						if @next_max_id.present?
							@show_more_bar = true
						else
							@show_more_bar = false
						end
						Rails.cache.write('next_max_id', @next_max_id)
					else
						@show_more_bar = true
					end
				else
					flash[:error] = "User #{params[:id]} is not found"
					redirect_to root_url
				end
			end
		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		        		if @query == NIL
		            		render :partial => "users/stream", :locals => { :media => @media, :username => params[:username], :layout => false, :status => :created}
		        		else
		        			render :partial => "users/followers_following_stream", :locals => { :media => @media, :username => params[:username], :layout => false, :status => :created}
		        		end
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

	def check_if_logged_in_user_is_private
		if current_user
			@client = Instagram.client(:access_token => session[:access_token])
			if @client.user.username != params[:id]
				@client = Instagram
			end
		else
			@client = Instagram
		end
	end
end

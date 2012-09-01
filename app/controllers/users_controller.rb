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
		@query = params[:query]
		if @show_more_data == false
			@show_more_data = true
			if @query.present?
				if @query == "followers"
					@user_id = params[:id]
					media_packet = Instagram.user_followed_by(@user_id, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						flash[:error] = "User #{params[:id]} is not found"
						redirect_to root_url
					end
				elsif @query == "following"
					@user_id = params[:id]
					media_packet = Instagram.user_follows(@user_id, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						flash[:error] = "User #{params[:id]} is not found"
						redirect_to root_url
					end
				end
			else
				@user_array = Instagram.user_search(params[:id], :count => 1)
				@username = params[:id]
				if @user_array.data.present?
					if @user_array.data.first.username == params[:id]			
						@user_id = @user_array.data.first.id
						@user = Instagram.user(@user_id)
						if current_user
							@user_relationship = Instagram.user_relationship(@user_id, :access_token => session[:access_token])
							media_packet = Instagram.user_recent_media(@user_id, :access_token => session[:access_token], :count => 18)
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
			end
		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		            	render :partial => "users/users_stream_container", :locals => { :media => @media, :user_id => @user_id, :username => params[:id], :layout => false, :status => :created}
		        	end
		    	end
		    end
		    return
		else
			if @query.present?
				if @query == "followers"
					@cursor ||= Rails.cache.fetch('next_cursor')
					media_packet = Instagram.user_followed_by(params[:id], :cursor => @cursor, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						flash[:error] = "User #{params[:id]} is not found"
						redirect_to root_url
					end
					@next_cursor = media_packet.pagination.next_cursor
					Rails.cache.write('next_cursor', @next_cursor)					
				elsif @query == "following"
					@cursor ||= Rails.cache.fetch('next_cursor')
					media_packet = Instagram.user_follows(params[:id], :cursor => @cursor, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						flash[:error] = "User #{params[:id]} is not found"
						redirect_to root_url
					end
					@next_cursor = media_packet.pagination.next_cursor
					Rails.cache.write('next_cursor', @next_cursor)
				end
			else		
				if current_user
					@next_max_id ||= Rails.cache.fetch('next_max_id')
					media_packet = Instagram.user_recent_media(params[:id], :max_id => @next_max_id, :access_token => session[:access_token], :count => 18)
					@media = media_packet.data
					@next_max_id = media_packet.pagination.next_max_id
					Rails.cache.write('next_max_id', @next_max_id)
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
end

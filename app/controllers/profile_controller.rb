class ProfileController < ApplicationController
	respond_to :html, :xml, :json
	before_filter :check_if_signed_in

	def show
		@show_more_data = false
		profile_stream_container
	end

	def profile_stream_container
		@query = params[:query]
		if @show_more_data == false
			@show_more_data = true
			if @query.present?
				if @query == "followers"
					@user_id = current_user.uid
					media_packet = Instagram.user_followed_by(@user_id, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						flash[:error] = "User #{current_user.username} is not found"
						redirect_to root_url
					end
				elsif @query == "following"
					@user_id = current_user.uid
					media_packet = Instagram.user_follows(@user_id, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						flash[:error] = "User #{current_user.username} is not found"
						redirect_to root_url
					end
				elsif @query == "feed"
					@user_id = current_user.uid
					media_packet = Instagram.user_media_feed(:access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_max_id = media_packet.pagination.next_max_id
						Rails.cache.write('next_max_id', @next_max_id)
						@media = media_packet.data
					else
						flash[:error] = "No Feed found"
						redirect_to root_url
					end					
				elsif @query == "likes"
					@user_id = current_user.uid
					media_packet = Instagram.user_liked_media(:access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_max_like_id = media_packet.pagination.next_max_like_id
						Rails.cache.write('next_max_like_id', @next_max_like_id)
						@media = media_packet.data
					else
						flash[:error] = "No Likes found"
						redirect_to root_url
					end					
				end
			else		
				@user_id = current_user.uid
				@user = Instagram.user(current_user.uid)
				media_packet = Instagram.user_recent_media(current_user.uid, :access_token => session[:access_token], :count => 18)
				@next_max_id = media_packet.pagination.next_max_id
				Rails.cache.write('next_max_id', @next_max_id)
				@media = media_packet.data
			end
		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		            	render :partial => "profile/profile_stream_container", :locals => { :media => @media, :user_id => @user_id, :username => current_user.username, :layout => false, :status => :created}
		        	end
		    	end
		    end
		    return
		else
			if @query.present?
				if @query == "followers"
					@cursor ||= Rails.cache.fetch('next_cursor')
					media_packet = Instagram.user_followed_by(current_user.uid, :cursor => @cursor, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						flash[:error] = "User #{current_user.uid} is not found"
						redirect_to root_url
					end
					@next_cursor = media_packet.pagination.next_cursor
					Rails.cache.write('next_cursor', @next_cursor)					
				elsif @query == "following"
					@cursor ||= Rails.cache.fetch('next_cursor')
					media_packet = Instagram.user_follows(current_user.uid, :cursor => @cursor, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						flash[:error] = "User #{current_user.uid} is not found"
						redirect_to root_url
					end
					@next_cursor = media_packet.pagination.next_cursor
					Rails.cache.write('next_cursor', @next_cursor)
				elsif @query == "feed"
					@max_id = Rails.cache.fetch('next_max_id')
					media_packet = Instagram.user_media_feed(:max_id => @max_id, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_max_id = media_packet.pagination.next_max_id
						Rails.cache.write('next_max_id', @next_max_id)
						@media = media_packet.data
					else
						flash[:error] = "Feed not found"
						redirect_to root_url
					end
					@next_max_id = media_packet.pagination.next_max_id
					Rails.cache.write('next_max_id', @next_max_id)					
				elsif @query == "likes"
					@max_like_id = Rails.cache.fetch('next_max_like_id')
					media_packet = Instagram.user_liked_media(:max_like_id => @max_like_id, :access_token => session[:access_token], :count => 28)
					if media_packet.data.present?
						@next_max_like_id = media_packet.pagination.next_max_like_id
						Rails.cache.write('next_max_like_id', @next_max_like_id)
						@media = media_packet.data
					else
						flash[:error] = "User #{current_user.uid} is not found"
						redirect_to root_url
					end
					@next_max_like_id = media_packet.pagination.next_max_like_id
					Rails.cache.write('next_max_like_id', @next_max_like_id)					
				end
			else		
				@next_max_id ||= Rails.cache.fetch('next_max_id')
				media_packet = Instagram.user_recent_media(current_user.uid, :max_id => @next_max_id, :access_token => session[:access_token], :count => 18)
				@media = media_packet.data
				@next_max_id = media_packet.pagination.next_max_id
				Rails.cache.write('next_max_id', @next_max_id)
			end
		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		        		if @query == NIL || @query == "likes" || @query == "feed"
		            		render :partial => "profile/stream", :locals => { :media => @media, :username => current_user.username, :layout => false, :status => :created}
		        		else
		        			render :partial => "profile/followers_following_stream", :locals => { :media => @media, :username => current_user.username, :layout => false, :status => :created}
		        		end
		        	end
		    	end
		    end
		    return
		end
	end

	protected

	def check_if_signed_in
		if !current_user
			flash[:error] = "You must be logged in view this page!"
			redirect_to root_url
		end
	end

end

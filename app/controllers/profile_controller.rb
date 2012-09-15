class ProfileController < ApplicationController
	respond_to :html, :xml, :json
	before_filter :check_if_signed_in

	def show
		@show_more_data = false
		@show_more_bar = false
		profile_stream_container
	end

	def profile_stream_container
		@query = params[:query]
		if @show_more_data == false
			@show_more_data = true
			if @query.present?
				if @query == "followers"
					@user_id = current_user.uid
					client = Instagram.client(:access_token => session[:access_token])
					@user = client.user
					media_packet = client.user_followed_by(:count => 28)
					@next_cursor = media_packet.pagination.next_cursor
					if @next_cursor.present?
						@show_more_bar = true
					else
						@show_more_bar = false
					end
					Rails.cache.write('next_cursor', @next_cursor)
					@media = media_packet.data
				elsif @query == "following"
					@user_id = current_user.uid
					client = Instagram.client(:access_token => session[:access_token])
					@user = client.user
					media_packet = client.user_follows(:count => 28)
					@next_cursor = media_packet.pagination.next_cursor
					if @next_cursor.present?
						@show_more_bar = true
					else
						@show_more_bar = false
					end
					Rails.cache.write('next_cursor', @next_cursor)
					@media = media_packet.data
				elsif @query == "photos"
					@user_id = current_user.uid
					client = Instagram.client(:access_token => session[:access_token])
					@user = client.user
					media_packet = client.user_recent_media(:count => 28)
					@next_max_id = media_packet.pagination.next_max_id
					if @next_max_id.present?
						@show_more_bar = true
					else
						@show_more_bar = false
					end
					Rails.cache.write('next_max_id', @next_max_id)
					@media = media_packet.data			
				elsif @query == "likes"
					@user_id = current_user.uid
					client = Instagram.client(:access_token => session[:access_token])
					@user = client.user
					media_packet = client.user_liked_media(:count => 28)
					@next_max_like_id = media_packet.pagination.next_max_like_id
					if @next_max_like_id.present?
						@show_more_bar = true
					else
						@show_more_bar = false
					end
					Rails.cache.write('next_max_like_id', @next_max_like_id)
					@media = media_packet.data				
				end
			else
				@user_id = current_user.uid
				client = Instagram.client(:access_token => session[:access_token])
				@user = client.user
				media_packet = client.user_media_feed(:count => 28)
				@next_max_id = media_packet.pagination.next_max_id
				if @next_max_id.present?
					@show_more_bar = true
				else
					@show_more_bar = false
				end
				Rails.cache.write('next_max_id', @next_max_id)
				@media = media_packet.data	
			end
		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		            	render :partial => "profile/profile_stream_container", :locals => { :show_more_bar => @show_more_bar, :media => @media, :user_id => @user_id, :username => current_user.username, :layout => false, :status => :created}
		        	end
		    	end
		    end
		    return
		else
			if @query.present?
				if @query == "followers"
					@cursor = Rails.cache.fetch('next_cursor')
					if @cursor.present?
						@show_more_bar = true
						client = Instagram.client(:access_token => session[:access_token])
						@user = client.user
						media_packet = client.user_followed_by(:cursor => @cursor, :count => 28)
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data	
					else
						@show_more_bar = true
					end		
				elsif @query == "following"
					@cursor = Rails.cache.fetch('next_cursor')
					if @cursor.present?
						@show_more_bar = true
						client = Instagram.client(:access_token => session[:access_token])
						@user = client.user
						media_packet = client.user_follows(:cursor => @cursor, :count => 28)
						@next_cursor = media_packet.pagination.next_cursor
						Rails.cache.write('next_cursor', @next_cursor)
						@media = media_packet.data
					else
						@show_more_bar = false
					end
				elsif @query == "photos"
					@next_max_id = Rails.cache.fetch('next_max_id')
					if @next_max_id.present?
						@show_more_bar = true
						client = Instagram.client(:access_token => session[:access_token])
						@user = client.user
						media_packet = client.user_recent_media(:max_id => @next_max_id, :count => 18)
						@media = media_packet.data
						@next_max_id = media_packet.pagination.next_max_id
						Rails.cache.write('next_max_id', @next_max_id)
					else
						@show_more_bar = false
					end		
				elsif @query == "likes"
					@max_like_id = Rails.cache.fetch('next_max_like_id')
					if @max_like_id.present?
						@show_more_bar = true
						client = Instagram.client(:access_token => session[:access_token])
						@user = client.user
						media_packet = client.user_liked_media(:max_like_id => @max_like_id, :count => 28)
						@next_max_like_id = media_packet.pagination.next_max_like_id
						Rails.cache.write('next_max_like_id', @next_max_like_id)
						@media = media_packet.data
					else
						@show_more_bar = false
					end			
				end
			else		
				@max_id = Rails.cache.fetch('next_max_id')
				if @max_id.present?
					@show_more_bar = true
					client = Instagram.client(:access_token => session[:access_token])
					@user = client.user
					media_packet = client.user_media_feed(:max_id => @max_id, :count => 28)
					@next_max_id = media_packet.pagination.next_max_id
					Rails.cache.write('next_max_id', @next_max_id)
					@media = media_packet.data	
				else
					@show_more_bar = false
				end	
			end
		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		        		if @query == NIL || @query == "likes" || @query == "photos"
		            		render :partial => "profile/stream", :locals => {:media => @media, :username => current_user.username, :layout => false, :status => :created}
		        		else
		        			render :partial => "profile/followers_following_stream", :locals => { :show_more_bar => @show_more_bar, :media => @media, :username => current_user.username, :layout => false, :status => :created}
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

require 'multi_json'
require 'open-uri'
class WelcomeController < ApplicationController
	respond_to :html, :xml, :json

	def index
		@show_more_data = false
		stream_container
	end

	def stream_container
		@querytype = params[:querytype]
		if @show_more_data == false
			@show_more_data = true
			if @querytype.present?
				if @querytype == "location"
					@latitude = params[:latitude]
					@longitude = params[:longitude]
					@query = params[:query]
					media_packet = Instagram.media_search(@latitude, @longitude, :count => 40)
					#raise media_packet = Instagram.location_recent_media(514276).to_yaml
					@media = media_packet.data
					#@max_id = get_max_id
					#@next_url = media_packet.pagination.next_url
					#Rails.cache.write('next_url', @next_url)
					@max_tag_id = get_max_id
					Rails.cache.write('max_tag_id', @max_tag_id)
				elsif @querytype == "tag"
					@query = params[:query]
					media_packet = Instagram.tag_recent_media(@query, :count => 24)
					@media = media_packet.data
					@max_tag_id = media_packet.pagination.next_max_tag_id
					Rails.cache.write('max_tag_id', @max_tag_id)
				elsif @querytype == "user"
					client = Instagram.client(:access_token => session[:access_token])
    				media_packet = client.user_recent_media
    				@media = media_packet.data
    				@max_id = media_packet.pagination.next_max_id
					Rails.cache.write('max_id', @max_id)
				end
					
			else
				@media = Instagram.media_popular(:count => 24)
			end

		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		            	render :partial => "welcome/stream_container", :locals => { :media => @media, :querytype => @querytype, :query => @query, :latitude => @latitude, :longitude => @longitude}, :layout => false, :status => :created
		        	end
		    	end
		    end
		    return
		else # Following is the code for SHOW MORE
			@querytype = params[:querytype]
			if @querytype.present?
				if @querytype == "location" ## PLease note that Location doesn't have pagination (next_url)
					@max_tag_id ||=  Rails.cache.fetch('max_tag_id')
					@latitude = params[:latitude]
					@longitude = params[:longitude]
					@query = params[:query]
					#media_packet = Instagram.get(@next_url)
					media_packet = Instagram.media_search(@latitude, @longitude, :count => 40, :max_tag_id => @max_tag_id)
					@media = media_packet.data
					@max_tag_id = get_max_id
					Rails.cache.write('max_tag_id', @max_tag_id)
				elsif @querytype == "tag"
					@max_tag_id ||= Rails.cache.fetch('max_tag_id')
					@query = params[:query]
					media_packet = Instagram.tag_recent_media(@query, :count => 24, :max_tag_id => @max_tag_id)
					@media = media_packet.data
					@max_tag_id = media_packet.pagination.next_max_tag_id
					Rails.cache.write('max_tag_id', @max_tag_id)
				elsif @querytype == "user"
					@max_id ||= Rails.cache.fetch('max_id')
					if @max_id.present?
						@query = params[:query]
						client = Instagram.client(:access_token => session[:access_token])
	    				media_packet = client.user_recent_media(:max_id => @max_id)
						@media = media_packet.data
						@max_id = media_packet.pagination.next_max_id
						Rails.cache.write('max_id', @max_id)
					end
				end
			else
				@media = Instagram.media_popular(:count => 24)
			end

		    respond_with do |format|
		        format.html do
		        	if request.xhr?
		            	render :partial => "welcome/stream", :locals => { :media => @media, :querytype => @querytype, :query => @query, :latitude => @latitude, :longitude => @longitude}, :layout => false, :status => :created
		        	end
		    	end
		    end
		end
	end

	def get_max_id
		@media.each do |media|
			media.id = media.id[/[^_]+/]
		end

		@sorted = @media.sort! { |a,b| a.id <=> b.id }
		return @sorted.first.id
	end

end

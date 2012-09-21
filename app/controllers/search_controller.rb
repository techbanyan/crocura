require 'facets/enumerable/each_by'
class SearchController < ApplicationController
	respond_to :html, :xml, :json

	def search
		@show_more_data = false
		@show_more_bar = true
		search_stream_container
	end

	def search_stream_container
		begin
			@query = params[:query]
			if @query == nil
				redirect_to root_url
				return
			elsif @query.empty?
				flash[:error] = "Please enter a valid search string"
				redirect_to root_url
				return
			end
			if @show_more_data == false
				@show_more_data = true
				if params[:tag]
					@querytype = "tag"
					media_packet = Instagram.tag_recent_media(@query, :count => 24, :access_token => session[:access_token])
					create_photos(media_packet.data)
					@media = media_packet.data
					@max_tag_id = media_packet.pagination.next_max_tag_id
					if @max_tag_id.present?
						@show_more_bar = true
					else
						@show_more_bar = false
					end
					Rails.cache.write('max_tag_id', @max_tag_id)
				elsif params[:people]
					@querytype = "people"
					media_packet = Instagram.user_search(@query)
					@media = media_packet.data
				elsif params[:location]
					@querytype = "location"
					media_packet = Instagram.tag_recent_media(@query.gsub(/\s+/, ""), :count => 24, :access_token => session[:access_token])
					create_photos(media_packet.data)
					@media = media_packet.data
					@max_tag_id = media_packet.pagination.next_max_tag_id
					if @max_tag_id.present?
						@show_more_bar = true
					else
						@show_more_bar = false
					end
					Rails.cache.write('max_tag_id', @max_tag_id)
				end
			    return
			else # Following is the code for SHOW MORE
				@querytype = params[:querytype]
				if @querytype == "tag"
					@max_tag_id ||= Rails.cache.fetch('max_tag_id')
					@query = params[:query]
					media_packet = Instagram.tag_recent_media(@query, :count => 24, :max_tag_id => @max_tag_id, :access_token => session[:access_token])
					create_photos(media_packet.data)
					@media = media_packet.data
					@max_tag_id = media_packet.pagination.next_max_tag_id
					Rails.cache.write('max_tag_id', @max_tag_id)
				elsif @querytype == "location"
					@max_tag_id ||= Rails.cache.fetch('max_tag_id')
					@query = params[:query]
					media_packet = Instagram.tag_recent_media(@query.gsub(/\s+/, ""), :count => 24, :max_tag_id => @max_tag_id, :access_token => session[:access_token])
					create_photos(media_packet.data)
					@media = media_packet.data
					@max_tag_id = media_packet.pagination.next_max_tag_id
					Rails.cache.write('max_tag_id', @max_tag_id)
				end
			    respond_with do |format|
			        format.html do
			        	if request.xhr?
			            	render :partial => "search/stream", :locals => { :media => @media}, :layout => false, :status => :created
			        	end
			    	end
			    end
			end
		rescue
			flash[:error] = "Please enter a valid search string"
			redirect_to root_url
		end			
	end

	protected

	def get_max_id
		@media.each do |media|
			media.id = media.id[/[^_]+/]
		end

		@sorted = @media.sort! { |a,b| a.id <=> b.id }
		return @sorted.first.id
	end

	def create_photos(media)
		if current_user
			media.each do |photo|
				check_photo = current_user.user_stream_photos.find_by_number(photo[:id])
				if check_photo.nil?
					@photo = UserStreamPhoto.new
					@photo.user_id = current_user.id
				else
					@photo = check_photo
				end
				@photo.number = photo[:id]
				@photo.data = photo
				@photo.save!
			end			
		else
			media.each do |photo|
				check_photo = Photo.find_by_number(photo[:id])
				if check_photo.nil?
					@photo = Photo.new
				else
					@photo = check_photo
				end
				@photo.number = photo[:id]
				@photo.data = photo
				@photo.save!
			end
		end
	end

end

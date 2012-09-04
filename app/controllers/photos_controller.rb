class PhotosController < ApplicationController
  	respond_to :html, :xml, :json

	def show
		#begin
			@photo = find_or_fetch_photo(params[:id])

			respond_with do |format|
				format.html do
					if request.xhr?
						render :partial => "photos/show_in_partial", :locals => { :photo => @photo }, :layout => false, :status => :created
					end
				end
			end
		#rescue
		#	flash[:error] = "Sorry! This photo is not found."
		#	redirect_to root_url
		#end
	end

	def index
		flash[:error] = "Sorry! You are not authorized to view the page"
		redirect_to root_url
	end

	def comment
		begin
			Instagram.create_media_comment(params[:photo_id], params[:comment_text], :access_token => session[:access_token])
			@photo = Instagram.media_item(params[:photo_id])
			respond_with do |format|
				format.html do
					if request.xhr?
						render :partial => "photos/comments", :locals => { :photo => @photo }, :layout => false, :status => :created
						#render :partial => "photos/test123", :layout => false, :status => :created
					else
						redirect_to photo_path(params[:photo_id])
					end
				end
			end
		rescue
			flash[:error] = "Sorry! You are not authorized to visit this page."
			redirect_to root_url
		end
	end

	def like
		# begin
			@photo = Instagram.media_item(params[:photo_id], :access_token => session[:access_token])
			if @photo.user_has_liked == FALSE
				Instagram.like_media(params[:photo_id], :access_token => session[:access_token])
				@photo = Instagram.media_item(params[:photo_id], :access_token => session[:access_token])
				update_photo(@photo)
				respond_with do |format|
					format.html do
						if request.xhr?
							render :partial => "photos/likes", :locals => { :photo => @photo }, :layout => false, :status => :created
						else
							redirect_to photo_path(params[:photo_id])
						end
					end
				end
			else
				Instagram.unlike_media(params[:photo_id], :access_token => session[:access_token])
				@photo = Instagram.media_item(params[:photo_id], :access_token => session[:access_token])
				update_photo(@photo)
				respond_with do |format|
					format.html do
						if request.xhr?
							render :partial => "photos/likes", :locals => { :photo => @photo }, :layout => false, :status => :created
						else
							redirect_to photo_path(params[:photo_id])
						end
					end
				end
			end
		# rescue
		# 	flash[:error] = "Sorry! You are not authorized to visit this page."
		# 	redirect_to root_url
		# end
	end

	def get_all_likes
		@likes = Instagram.media_likes(params[:photo_id])
		respond_with do |format|
			format.html do
				if request.xhr?
					render :partial => "photos/likes_show", :locals => { :likes => @likes, :photo_id => params[:photo_id] }, :layout => false, :status => :created
				else
					redirect_to photo_path(params[:id])
				end
			end
		end
	end

	def get_all_comments
		@comments = Instagram.media_comments(params[:photo_id])
		respond_with do |format|
			format.html do
				if request.xhr?
					render :partial => "photos/comments_show", :locals => { :comments => @comments, :photo_id => params[:photo_id] }, :layout => false, :status => :created
				else
					redirect_to photo_path(params[:id])
				end
			end
		end
	end

	protected

	def find_or_fetch_photo(photo_id)
		if current_user
			@photo = current_user.user_stream_photos.find_by_number(photo_id)
			if @photo.nil?
				return @photo = Instagram.media_item(photo_id, :access_token => session[:access_token])
			else
				return @photo = @photo.data
			end			
		else
			@photo = Photo.find_by_number(photo_id)
			if @photo.nil?
				return @photo = Instagram.media_item(photo_id, :access_token => session[:access_token])
			else
				return @photo = @photo.data
			end
		end
	end

	def update_photo(photo)
		if current_user
			old_photo = current_user.user_stream_photos.find_by_number(photo[:id])
			if old_photo
				old_photo.number = photo[:id]
				old_photo.data = photo
				old_photo.save!
			end
		else
			old_photo = Photo.find_by_number(photo[:id])
			if old_photo
				old_photo.number = photo[:id]
				old_photo.data = photo
				old_photo.save!
			end
		end
	end
end

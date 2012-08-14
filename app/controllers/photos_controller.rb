class PhotosController < ApplicationController
  	respond_to :html, :xml, :json

	def show
		#begin
			@photo = Instagram.media_item(params[:id], :access_token => session[:access_token])
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
end

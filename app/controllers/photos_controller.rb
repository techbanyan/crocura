class PhotosController < ApplicationController

	def show
		begin
			@photo = Instagram.media_item(params[:id])
		rescue
			flash[:error] = "Sorry! This photo is not found."
			redirect_to root_url
		end
	end

	def index
		flash[:error] = "Sorry! You are not authorized to view the page"
		redirect_to root_url
	end
end

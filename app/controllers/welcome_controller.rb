require 'json'
class WelcomeController < ApplicationController

	def index
		@query = params[:query]
		if @query.present?
			if params[:querytype] == "location"
				@media = Instagram.media_search(params[:latitude], params[:longitude])
			elsif params[:querytype] == "tag"
				@media = Instagram.tag_recent_media(params[:query]).data
			end
		else
			@media = Instagram.media_popular(:count => 18)
		end
	end
end

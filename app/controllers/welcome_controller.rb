require 'json'
class WelcomeController < ApplicationController

	def index
		@query = params[:query]
		if @query.present?
			if params[:querytype] == "location"
				raise @media = Instagram.media_search(params[:latitude], params[:longitude]).to_yaml
			elsif params[:querytype] == "tag"
				@media = Instagram.tag_recent_media(params[:query]).data
			end
		else
			@media = Instagram.media_popular
		end
	end
end

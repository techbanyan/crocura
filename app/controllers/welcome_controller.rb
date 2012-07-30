require 'json'
class WelcomeController < ApplicationController
	respond_to :html, :xml, :json

	def index
		stream
	end

	def stream
		@query = params[:query]
		if @query.present?
			if params[:querytype] == "location"
				media = Instagram.media_search(params[:latitude], params[:longitude], :count => 300)
				#@media = media.paginate(:per_page => 18)
				@media = media
			elsif params[:querytype] == "tag"
				media = Instagram.tag_recent_media(params[:query], :count => 63).data
				#@media = media.paginate(:per_page => 18)
				@media = media 
			end
		else
			@media = Instagram.media_popular(:count => 45)
		end

	    respond_with do |format|
	        format.html do
	        	if request.xhr?
	            	render :partial => "welcome/stream", :locals => { :media => @media }, :layout => false, :status => :created
	        	end
	    	end
	    end
	end
end

class UsersController < ApplicationController
	def index
		flash[:error] = "Sorry! You are not authorized to view the page"
		redirect_to root_url
		return
	end

	def show
	end
end

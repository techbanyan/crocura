class HeaderLinksController < ApplicationController
	def how_it_works
		@element = Element.first
		@how_it_works = @element.how_it_works
	end

	def faq
		@element = Element.first
		@faq = @element.faq
	end

	def help
		@element = Element.first
		@help = @element.help
	end

	def about
		@element = Element.first
		@about = @element.about
	end

	def privacy
		@element = Element.first
		@privacy = @element.privacy
	end
end

class Photo < ActiveRecord::Base
  	attr_accessible :data, :number
	serialize :data, JSON

	def self.flush_out_old_photos
		Photo.destroy_all(["created_at < ?", Time.now - 6.hours])
	end
end

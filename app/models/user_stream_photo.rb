class UserStreamPhoto < ActiveRecord::Base
  	attr_accessible :data, :number
	serialize :data, JSON
	belongs_to :user

	validates :user_id, :presence => true
end

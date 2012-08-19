class Photo < ActiveRecord::Base
  	attr_accessible :data, :number
	serialize :data, JSON
end

class Tab < ActiveRecord::Base
  attr_accessible :query, :query_type, :latitude, :longitude, :rank
  geocoded_by :query

  validates :query,  :presence   => true
  validates :query_type,  :presence   => true 
  validates :rank, :presence => true
  
  after_validation :geocode, :if => :query_changed?
end

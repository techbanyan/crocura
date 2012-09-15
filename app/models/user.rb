class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid, :username

  has_many :user_stream_photos, :dependent => :destroy

  def self.create_with_omniauth(auth)
  	create! do |user|
  		user.provider = auth["provider"]
  		user.uid = auth["uid"]
  		user.name = auth["info"]["name"]
  		user.username = auth["info"]["nickname"]
      user.profile_picture = auth["info"]["profile_picture"]
  	end
  end
end

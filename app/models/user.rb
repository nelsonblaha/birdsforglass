class User < ActiveRecord::Base
  attr_accessible :name
  has_many :authorizations, dependent: :destroy
  has_many :cards, dependent: :destroy

  def birds_nearby(latitude,longitude)
    HTTParty.get("http://ebird.org/ws1.1/data/obs/geo/recent?lng="+longitude.to_s+"&lat="+latitude.to_s+"&fmt=json&dist=5&back=14&includeProvisional=true")
  end

  def google
    Authorization.first
  end 
end

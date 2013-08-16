class Authorization < ActiveRecord::Base
  attr_accessible :access_token, :oauth_token_secret, :provider, :refresh_token, :uid, :user_id
  belongs_to :user

  def self.find_or_create(auth_hash)
    auth = Authorization.where(provider:auth_hash["provider"],uid:auth_hash["uid"]).first
    if auth.nil?
        user = User.where(email:auth_hash["info"]["email"]).first_or_create
        auth = Authorization.create(user_id:user.id,provider:auth_hash["provider"],uid:auth_hash["uid"],access_token:auth_hash["credentials"]['token'])
        if auth_hash['credentials']['refresh_token']
          auth.refresh_token = auth_hash['credentials']['refresh_token']
        end
        auth.save
      end
      auth
  end

  def refresh_access_token(uri,client_id,client_secret)
    if self.refresh_token
     begin
      response = HTTParty.post(uri, :body => {refresh_token: self.refresh_token, client_id: client_id, client_secret: client_secret, grant_type:'refresh_token'})
                    self.access_token = response['access_token']
                    self.save
                    return true
    rescue
    end
   end
   return false
  end

  def location
    require "mirror-api"
    api = Mirror::Api::Client.new(self.access_token)
    if location = api.locations.list.items.first
      return [location.latitude,location.longitude,location.accuracy]
    end
  end

  def delete_all_cards
    require "mirror-api"
    api = Mirror::Api::Client.new(self.access_token)

    while items = api.timeline.list.items && items.count > 0
      items.each do |card|
        api.timeline.delete(card.id)
      end  
    end
  end

  def update_cards
    location = self.location
    birds = self.user.birds_nearby(location[0],location[1])
    require "mirror-api"
    api = Mirror::Api::Client.new(self.access_token)

    self.delete_all_cards

    # add new bird cards
    birds.each do |bird|
      api.timeline.insert({text:bird['comName'],bundleId:"birds"})
    end
  end
end 

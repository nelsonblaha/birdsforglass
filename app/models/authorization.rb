class Authorization < ActiveRecord::Base
  attr_accessible :access_token, :oauth_token_secret, :provider, :refresh_token, :uid, :user_id
  belongs_to :user
  after_create :update_cards

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
    begin
      api = Mirror::Api::Client.new(self.access_token)
      if location = api.locations.list.items.first
        return [location.latitude,location.longitude,location.accuracy]
      end
    rescue
      return false
    end
  end

  def delete_all_cards
    require "mirror-api"
    api = Mirror::Api::Client.new(self.access_token)

    while (items = api.timeline.list.items) && items.count > 0
      items.each do |card|
        api.timeline.delete(card.id)
      end  
    end
  end

  def delete_missing_cards(birds)
    require "mirror-api"
    api = Mirror::Api::Client.new(self.access_token)

    com_names = birds.map { |bird| bird['comName']}

    self.user.cards.each do |card|
      puts "considering user's "+card.com_name+" card for deletion..."
      unless com_names.include?(card.com_name)
        puts "  didn't find the card, deleting..."
        api.timeline.delete(card.mirror_id)
        Card.where(com_name:bird['comName'],user_id:self.user.id).destroy_all
      end
    end
  end

  def update_cards
      if location = self.location
        birds = self.user.birds_nearby(location[0],location[1])
        require "mirror-api"
        api = Mirror::Api::Client.new(self.access_token)

        self.delete_missing_cards(birds)

        # add new bird cards
        birds.each do |birdjson|
          puts "deciding on "+birdjson['comName']
          bird = Bird.where(com_name:birdjson['comName'],sci_name:birdjson['sciName']).first_or_create
          unless Card.where(bird_id:bird.id,user_id:self.user.id).count > 0
            puts "adding card for "+birdjson['comName']
            card = Card.create(com_name:bird.com_name,bird_id:bird.id,user_id:self.user.id)
            card.insert_card(birdjson)
          end
        end
      end
  end
end 

class Authorization < ActiveRecord::Base
  attr_accessible :access_token, :oauth_token_secret, :provider, :refresh_token, :uid, :user_id
  belongs_to :user

  def self.find_or_create(auth_hash)
    auth = Authorization.where(provider:auth_hash["provider"],uid:auth_hash["uid"]).first
    if auth.nil?
        user = User.where(email:auth_hash["info"]["email"]).first_or_create
        auth = Authorization.create(user_id:user.id,provider:auth_hash["provider"],uid:auth_hash["uid"],access_token:auth_hash["credentials"]['token'])
        #if auth_hash['credentials']['secret']
          #auth.oauth_token_secret = auth_hash['credentials']['secret']
        #end
        if auth_hash['credentials']['refresh_token']
          auth.refresh_token = auth_hash['credentials']['refresh_token']
        end
        auth.save
      end
      auth
  end
end

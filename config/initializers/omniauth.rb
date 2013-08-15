Rails.application.config.middleware.use OmniAuth::Builder do
#   #twitter
#     provider :twitter, TWITTER_KEY, TWITTER_SECRET
  # google    
    provider :google_oauth2, GOOGLE_KEY, GOOGLE_SECRET, { access_type: "offline", scope: "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/glass.timeline https://www.googleapis.com/auth/glass.location" }
end
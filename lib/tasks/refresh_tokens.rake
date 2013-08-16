desc "refresh access tokens for google accounts"
task :refresh_tokens => :environment do
  #Google 
    Authorization.all.each do |g|
    begin
      g.refresh_access_token("https://accounts.google.com/o/oauth2/token",GOOGLE_KEY,GOOGLE_SECRET)
        puts "got it."
    rescue
        puts "oops! couldn't get the new Google access token"
    end
  end
end

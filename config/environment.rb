# Load the rails application
require File.expand_path('../application', __FILE__)

#google credentials
GOOGLE_KEY = ENV["GOOGLE_KEY"]
GOOGLE_SECRET = ENV["GOOGLE_SECRET"]

# Initialize the rails application
Birds::Application.initialize!

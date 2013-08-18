class Card < ActiveRecord::Base
  attr_accessible :mirror_id, :user_id, :com_name, :bird_id

  belongs_to :user
  belongs_to :bird

  def insert_card(birdjson = nil)
    require "mirror-api"
    api = Mirror::Api::Client.new(self.user.google.access_token)
    
    if birdjson
      bird_count = birdjson['howMany'].to_s
    else
      bird_count = "unknown number"
    end

    self.mirror_id = api.timeline.insert({bundleId: "birdsForGlass", html: "<article>\n  <figure>\n    <img src=\""+self.bird.set_and_return_image_url+"\">\n  </figure>\n  <section>\n    <table class=\"text-small align-justify\"> \n      <tbody>\n        <tr>\n                    <td>"+self.bird.com_name+"</td>\n        </tr>\n        <tr>\n                    <td>"+self.bird.sci_name+"</td>\n        </tr>\n        <tr>\n                    <td>"+bird_count+" sighted nearby.</td>\n        </tr>\n      </tbody>\n    </table>\n  </section>\n</article>\n"})['id']
    self.save
  end
end

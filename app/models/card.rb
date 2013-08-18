class Card < ActiveRecord::Base
  attr_accessible :mirror_id, :user_id, :com_name

  belongs_to :user

  def insert_card(bird)
    require "mirror-api"
    api = Mirror::Api::Client.new(self.user.google.access_token)
    image_url = Bird.where(com_name:bird['comName']).first_or_create.set_and_return_image_url
    self.mirror_id = api.timeline.insert({sourceItemId:bird['comName'],bundleId: "birdsForGlass", html: "<article>\n  <figure>\n    <img src=\""+image_url+"\">\n  </figure>\n  <section>\n    <table class=\"text-small align-justify\"> \n      <tbody>\n        <tr>\n                    <td>"+bird['comName']+"</td>\n        </tr>\n        <tr>\n                    <td>"+bird['sciName']+"</td>\n        </tr>\n        <tr>\n                    <td>"+bird['howMany'].to_s+" sighted nearby.</td>\n        </tr>\n      </tbody>\n    </table>\n  </section>\n</article>\n"})['id']
    self.save
  end
end

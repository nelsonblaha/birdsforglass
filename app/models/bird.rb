class Bird < ActiveRecord::Base
  attr_accessible :com_name, :image_url

  def image_url
    unless bird.image_url(comName = nil)
      self.image_url = Google::Search::Image.new(:query => self.com_name).first.uri
      self.save
    end

    self.image_url
  end
end

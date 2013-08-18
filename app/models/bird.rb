class Bird < ActiveRecord::Base
  attr_accessible :com_name, :sci_name, :image_url
  has_many :cards

  def set_and_return_image_url
    unless self.image_url
      self.image_url = Google::Search::Image.new(:query => self.com_name).first.uri
      self.save
    end

    self.image_url
  end
end

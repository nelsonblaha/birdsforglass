class Card < ActiveRecord::Base
  attr_accessible :mirror_id, :user_id

  belongs_to :user
end

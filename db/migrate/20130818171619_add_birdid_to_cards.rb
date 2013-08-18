class AddBirdidToCards < ActiveRecord::Migration
  def change
    add_column :cards, :bird_id, :integer
  end
end

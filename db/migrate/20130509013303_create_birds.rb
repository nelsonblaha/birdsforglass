class CreateBirds < ActiveRecord::Migration
  def change
    create_table :birds do |t|
      t.string :com_name
      t.string :image_url

      t.timestamps
    end
  end
end

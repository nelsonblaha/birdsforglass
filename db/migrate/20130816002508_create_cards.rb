class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :mirror_id
      t.integer :user_id

      t.timestamps
    end
  end
end

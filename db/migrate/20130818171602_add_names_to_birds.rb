class AddNamesToBirds < ActiveRecord::Migration
  def change
    add_column :birds, :sci_name, :string
  end
end

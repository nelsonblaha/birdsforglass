class AddComnameToCards < ActiveRecord::Migration
  def change
    add_column :cards, :com_name, :string
  end
end

class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.integer :user_id
      t.string :refresh_token
      t.string :access_token
      t.string :oauth_token_secret

      t.timestamps
    end
  end
end

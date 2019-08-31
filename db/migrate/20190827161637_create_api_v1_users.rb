class CreateApiV1Users < ActiveRecord::Migration[5.2]
  def change
    create_table :api_v1_users do |t|
      t.string :create
      
      t.string :display_name
      t.string :profile_img_url
      t.string :spotify_id
      t.string :spotify_url
      t.string :access_token
      t.string :refresh_token
      t.string :email

      t.timestamps
    end
  end
end

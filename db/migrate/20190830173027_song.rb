class Song < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :create
      
      t.string :name
      t.integer :duration_ms
      t.string :spotify_url
      t.string :href
      t.string :spotify_id
      t.string :preview_url
      t.string :uri
      t.integer :album_id

      t.timestamps
    end
  end
end

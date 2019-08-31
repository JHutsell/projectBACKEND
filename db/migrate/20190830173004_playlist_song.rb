class PlaylistSong < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_songs do |t|
      t.string :create
      
      t.integer :song_id
      t.integer :playlist_id

      t.timestamps
    end
  end
end

class Song < ApplicationRecord
    has_many :playlist_songs
    has_many :playlists, through: :playlist_songs

    def self.from_json(json)
        assignment_hash = {
          name: json["name"],
          duration_ms: json["duration_ms"],
        #   explicit: json["explicit"],
          spotify_url: json["external_urls"]["spotify"],
          href: json["href"],
          spotify_id: json["id"],
          preview_url: json["preview_url"],
          uri: json["uri"]
        }
        Song.find_or_create_by(assignment_hash)
      end

end
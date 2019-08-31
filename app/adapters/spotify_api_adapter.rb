class SpotifyApiAdapter
    
    def self.urls
        {
            "auth" => "https://accounts.spotify.com/api/token",
            "me" => "https://api.spotify.com/v1/me",
            "recent_tracks" => "https://api.spotify.com/v1/me/player/recently-played",
            "top_artists" => "https://api.spotify.com/v1/me/top/artists/"
        }
    end

    def self.body_params
        body = {
            client_id: ENV['CLIENT_ID'],
            client_secret: ENV["CLIENT_SECRET"]
        }
    end

    def self.login(code)
        body = body_params.dup
        body[:grant_type] = "authorization_code"
        body[:code] = code
        body[:redirect_uri] = ENV['REDIRECT_URI']

        auth_response = RestClient.post(urls["auth"], body)
        JSON.parse(auth_response.body)
    end

    def self.getUserData(access_token) 
        header = {
            "Authorization": "Bearer #{access_token}"
        }

        user_response = RestClient.get(urls["me"], header)

        JSON.parse(user_response.body)
    end

    def self.get_user_library(user)
        # Update user's refresh token if necessary
        user.refresh_access_token  
    
        # Create header and parameters for API get request for user's library
        header = {
          Authorization: "Bearer #{user.access_token}"
        }
        query_params = {
          limit: 50
        }
        initial_url = "https://api.spotify.com/v1/me/tracks"
    
        # Initialize variables to control looping through response pages
        next_page = true
        response = nil
        # Loop over response pages, saving user's library data until there is not a "next" key
        while next_page do
          url = !response ?  "#{initial_url}?#{query_params.to_query}" : response["next"]
          begin
            response = JSON.parse(RestClient.get(url, header))
          rescue RestClient::Exceptions::OpenTimeout
            # If there is a timeout error, force loop to exit
            response = {}
          end
          persist_user_library(user, response["items"])
          next_page = false if !response["next"]
        end
    end

    def self.persist_user_library(user, items)
            # TODO: decide if this belongs here or in one of the models??
        
            # iterate over each item (a track in the user's library) and persist/create associations
            items.each do |item|
                track = Track.from_json(item["track"])
                album = Album.from_json(item["track"]["album"])
                album.tracks << track
                artists = Artist.many_from_array(item["track"]["artists"])
                # Handle validation error from assigning a track to an artist more than once
                    artists.each do |artist|
                        persist_additional_artist_data(user, artist)
                        begin
                            artist.tracks << track
                        rescue ActiveRecord::RecordInvalid => invalid
                            puts invalid.record.errors.inspect
                        end
                    end
                TrackUser.create(user_id: user.id,
                track_id: track.id,
                added_at: item["added_at"])
            end
    end


    def self.get_recently_played_tracks(access_token)
        header = {
            "Authorization": "Bearer #{access_token}"
        }

        recent_tracks = RestClient.get(urls["recent_tracks"], header)

        response = JSON.parse(recent_tracks.body)
        response["items"]
    end

    def self.get_user_top_artists(access_token)
        header = {
            "Authorization": "Bearer #{access_token}"
        }

        top_artists = RestClient.get(urls["top_artists"], header)
        response = JSON.parse(top_artists)
        response["items"]
    end


end
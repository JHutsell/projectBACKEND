class SpotifyApiAdapter
    
    def self.urls
        {
            "auth" => "https://accounts.spotify.com/api/token",
            "me" => "https://api.spotify.com/v1/me",
            "recent_tracks" => "https://api.spotify.com/v1/me/player/recently-played",
            "top_artists" => "https://api.spotify.com/v1/me/top/artists/",
            "playlists" => "https://api.spotify.com/v1/me/playlists",
            "currently_playing" => "https://api.spotify.com/v1/me/player/currently-playing",
            "reccomendations" => "https://api.spotify.com/v1/recommendations",
            "search" => "https://api.spotify.com/v1/search?q="
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

    def self.get_recently_played_tracks(access_token)

        # user.refresh_access_token

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
        response = JSON.parse(top_artists.body)
        response["items"]
    end

    def self.get_user_playlists(access_token)
        header = {
            "Authorization": "Bearer #{access_token}"
        }

        playlists = RestClient.get(urls["playlists"], header)
        response = JSON.parse(playlists.body)
        response["items"]
    end

    # def self.get_user_reccomendations(access_token)
    #     header = {
    #         "Authorization": "Bearer #{access_token}"
    #     }

    #     reccomendations = RestClient.get(urls["reccomendations"], header)
    #     byebug
    #     response = JSON.parse(reccomendations.body)
    #     response["items"]
    # end

    def self.get_user_currently_playing(access_token)
        header = {
            "Authorization": "Bearer #{access_token}"
        }

        current_song = RestClient.get(urls["currently_playing"], header)
        # byebug
        current_song_json = current_song.to_json
        response = JSON.parse(current_song.body)
        response
    end

    def self.get_search_song(access_token, term)
        header = {
            "Authorization": "Bearer #{access_token}"
        }

        # https://api.spotify.com/v1/search?q=
        # "https://api.spotify.com/v1/search?q=abba&type=track&market=US"

        searchedd = urls["search"] + term + "&type=track"
        song = RestClient.get(searchedd, header)
        response = JSON.parse(song.body)
        response
    end


end
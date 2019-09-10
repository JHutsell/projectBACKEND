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
            "search" => "https://api.spotify.com/v1/search?q=",
            "add_to_playlist" => "https://api.spotify.com/v1/playlists/"
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
        response = JSON.parse(current_song.body)
        response
    end

    def self.get_search_song(access_token, term)
        header = {
            "Authorization": "Bearer #{access_token}"
        }

        # "https://api.spotify.com/v1/search?q=abba&type=track&market=US"

        searched = urls["search"] + term + "&type=track"
        song = RestClient.get(searched, header)
        response = JSON.parse(song.body)
        response
    end

    def self.add_song_to_playlist(access_token, playlist_id, song_uri)
        require 'uri'
        require 'net/http'

        string = "https://api.spotify.com/v1/playlists/" + playlist_id + "/tracks?uris=spotify%3Atrack%3A" + song_uri
        url = URI(string)
        # byebug
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        
        request = Net::HTTP::Post.new(url)
        request["Authorization"] = "Bearer #{access_token}"
        request["Accept"] = 'application/json'
        # request["User-Agent"] = 'PostmanRuntime/7.16.3'
        # request["Cache-Control"] = 'no-cache'
        # request["Postman-Token"] = '617fcab3-bb41-485f-af3d-be890bd10c3c,4794609a-d835-4f31-a576-1a0eebc7777e'
        request["Host"] = 'api.spotify.com'
        request["Accept-Encoding"] = 'gzip, deflate'
        # request["Cookie"] = 'sp_ab=%7B%7D; sp_t=43c8692abd99f7abcab87cee9b998f7f'
        # request["Content-Length"] = ''
        # request["Connection"] = 'keep-alive'
        # request["cache-control"] = 'no-cache'
        
        response = http.request(request)
        puts response.read_body
    end

end
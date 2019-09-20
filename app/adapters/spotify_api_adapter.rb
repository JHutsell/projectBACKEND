class SpotifyApiAdapter
    
    def self.urls
        {
            "auth" => "https://accounts.spotify.com/api/token",
            "me" => "https://api.spotify.com/v1/me",
            "recent_tracks" => "https://api.spotify.com/v1/me/player/recently-played",
            "top_artists" => "https://api.spotify.com/v1/me/top/artists/",
            "playlists" => "https://api.spotify.com/v1/me/playlists",
            "currently_playing" => "https://api.spotify.com/v1/me/player/currently-playing",
            "reccomendations" => "https://api.spotify.com/v1/recommendations?seed_tracks=",
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

    def self.get_user_reccomendations(access_token, song_1, song_2, song_3, song_4, song_5)
        header = {
            "Authorization": "Bearer #{access_token}"
        }

        recco_url = urls["reccomendations"] + song_1 + "&seed_tracks= " + song_2 + "&seed_tracks= " + song_3 + "&seed_tracks= " + song_4 + "&seed_tracks= " + song_5

        reccomendations = RestClient.get(recco_url, header)
        response = JSON.parse(reccomendations.body)
        response["tracks"]
    end

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
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        
        request = Net::HTTP::Post.new(url)
        request["Authorization"] = "Bearer #{access_token}"
        request["Accept"] = 'application/json'
        request["Host"] = 'api.spotify.com'
        request["Accept-Encoding"] = 'gzip, deflate'
        
        response = http.request(request)
        puts response.read_body
    end

    def self.create_new_user_playlist(access_token, spotify_id, name)
        require 'uri'
        require 'net/http'

        string = "https://api.spotify.com/v1/users/" + spotify_id + "/playlists"
        url = URI(string)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["Authorization"] = "Bearer #{access_token}"        
        request["Content-Type"] = 'application/json'
        request["Host"] = 'api.spotify.com'
        request["Accept-Encoding"] = 'gzip, deflate'
        request["Content-Length"] = '40'
        request["Connection"] = 'keep-alive'
        request["cache-control"] = 'no-cache'
        request.body = "{\"name\":\"#{name}\", \"public\":true}"
        response = http.request(request)
        puts response.read_body
    end

end
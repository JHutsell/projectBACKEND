class Api::V1::SongsController < ApplicationController

    def index 
        @songs = current_user.songs
        render json: @songs
    end

    def recent_songs
        # auth_params = SpotifyApiAdapter.login(params[:code])
        # recent_songs_data = SpotifyApiAdapter.get_recently_played_tracks(auth_params["access_token"])

        recent_songs_data = SpotifyApiAdapter.get_recently_played_tracks(current_user)
        byebug
        render json: recent_songs_data
    end

end

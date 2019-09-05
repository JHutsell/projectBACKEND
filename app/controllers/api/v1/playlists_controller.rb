class Api::V1::PlaylistsController < ApplicationController

    def index 
        @playlists = current_user.playlists
        render json: @playlists
    end

    def user_playlists
        # auth_params = SpotifyApiAdapter.login(params[:code])
        # recent_songs_data = SpotifyApiAdapter.get_recently_played_tracks(auth_params["access_token"])

        playlists_data = SpotifyApiAdapter.get_user_playlists(current_user.access_token)
        byebug
        render json: playlists_data
    end

end

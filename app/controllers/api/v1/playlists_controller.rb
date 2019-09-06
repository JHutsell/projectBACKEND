class Api::V1::PlaylistsController < ApplicationController

    def index 
        @playlists = current_user.playlists
        render json: @playlists
    end

    def user_playlists
        playlists_data = SpotifyApiAdapter.get_user_playlists(current_user.access_token)
        render json: playlists_data
    end

end

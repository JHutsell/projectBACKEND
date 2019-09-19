class Api::V1::PlaylistsController < ApplicationController

    def index 
        @playlists = current_user.playlists
        render json: @playlists
    end

    def user_playlists
        playlists_data = SpotifyApiAdapter.get_user_playlists(current_user.access_token)
        render json: playlists_data
    end

    def make_new_playlist
        playlist_data = SpotifyApiAdapter.create_new_user_playlist(current_user.access_token, current_user.spotify_id, params[:name])
        render json: playlist_data
    end

end

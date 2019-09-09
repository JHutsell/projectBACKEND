class Api::V1::SongsController < ApplicationController

    def index 
        @songs = current_user.songs
        render json: @songs
    end

    def recent_songs
        # auth_params = SpotifyApiAdapter.login(params[:code])
        # recent_songs_data = SpotifyApiAdapter.get_recently_played_tracks(auth_params["access_token"])

        recent_songs_data = SpotifyApiAdapter.get_recently_played_tracks(current_user.access_token)
        # byebug
        render json: recent_songs_data
    end

    def top_artists
        top_artists_data = SpotifyApiAdapter.get_user_top_artists(current_user.access_token)
        render json: top_artists_data
    end

    def current_song
        current_song_data = SpotifyApiAdapter.get_user_currently_playing(current_user.access_token)
        render json: current_song_data
    end

    def searched_song
        searched_song_data = SpotifyApiAdapter.get_search_song(current_user.access_token, params[:term])
        render json: searched_song_data
    end

end

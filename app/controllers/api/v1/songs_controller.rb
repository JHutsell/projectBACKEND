class SongsController < ApplicationController

    skip_before_action :authorized

    def index 
        @songs = current_user.songs
        render json: @songs
    end

    def recent_songs
        recent_songs_data = SpotifyApiAdapter.get_recently_played_tracks(current_user.access_token)
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

    def add_song_to_playlist
        post_list = SpotifyApiAdapter.add_song_to_playlist(current_user.access_token, params[:playlist_id], params[:song_uri])
        render json: post_list
    end

    def get_song_recommendations
        recco_list = SpotifyApiAdapter.get_user_reccomendations(current_user.access_token, params[:song_1], params[:song_2], params[:song_3], params[:song_4], params[:song_5])
        render json: recco_list
    end



end

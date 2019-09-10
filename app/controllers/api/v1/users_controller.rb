class Api::V1::UsersController < ApplicationController
    skip_before_action :authorized

    def create
        auth_params = SpotifyApiAdapter.login(params[:code])
        user_data = SpotifyApiAdapter.getUserData(auth_params["access_token"])
        # byebug 
        
        user = User.find_or_create_by(user_params(user_data))
        img_url = user_data["images"][0] ? user_data["images"][0]["url"] : nil
        
        recent_tracks = SpotifyApiAdapter.get_recently_played_tracks(auth_params["access_token"])
        top_artists = SpotifyApiAdapter.get_user_top_artists(auth_params["access_token"])
        playlists = SpotifyApiAdapter.get_user_playlists(auth_params["access_token"])
        # current_song = SpotifyApiAdapter.get_user_currently_playing(auth_params["access_token"])
        # reccos = SpotifyApiAdapter.get_user_reccomendations(auth_params["access_token"])
        
        # byebug
        #encodedAccess = issue_token({token: auth_params["access_token"]})
        #encodedRefresh = issue_token({token: auth_params["refresh_token"]})
        
        payload = {user_id: user.id}
        token = issue_token(payload)
        
        
        user.update(profile_img_url: img_url, access_token: auth_params["access_token"], refresh_token: auth_params["refresh_token"])
        byebug
        render json: {recent_tracks: recent_tracks, top_artists: top_artists, playlists: playlists, auth_response_json: auth_response_json(user, token)}
        # if user.valid?
        #     # render json: auth_response_json(user, token) # see application_controller.rb
        # else
        #     render json: { errors: user.errors.full_messages }
        # end 
        # byebug

        # render json: user.to_json(:except => [:access_token, :refresh_token, :created_at, :updated_at])
    end

    def index
        @users = User.all 
        render json: @users
    end

    def addFriend
        user1 = User.find(params[:follower])
        user2 = User.find(params[:following])
        user2.followers << user1
        render json: {added:true}
    end

    def deleteFriend
        user1 = User.find(params[:follower])
        user2 = User.find(params[:following])
        user2.followers.delete(user1)
        render json: {added:false}
    end

    private
    
    def user_params(user_data)
        params = {
            email: user_data["email"],
            display_name: user_data["display_name"],
            spotify_url: user_data["external_urls"]["spotify"],
        }
    end

end

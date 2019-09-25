class Api::V1::SessionsController < ApplicationController

  skip_before_action :authorized, only: [:create]
  
    def create
      query_params = {
        client_id: ENV["CLIENT_ID"],
        response_type: "code",
        redirect_uri: ENV["REDIRECT_URI"],
        scope: "user-read-email user-top-read user-read-currently-playing user-read-playback-state user-read-private playlist-modify-public playlist-modify-private playlist-read-private user-read-recently-played user-library-read",
        show_dialog: true
      }
      byebug
  
      url = "https://accounts.spotify.com/authorize"
      redirect_to "#{url}?#{query_params.to_query}"
    end

  end

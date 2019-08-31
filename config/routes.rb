#   # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
# end

Rails.application.routes.draw do
  
  # namespace :api do
  #   namespace :v1 do
  #     resources :playlist_songs
  #   end
  # end

  # namespace :api do
  #   namespace :v1 do
  #     resources :songs
  #     # get "/songs/recent", to: "songs#recent_songs"
  #   end
  # end

  # namespace :api do
  #   namespace :v1 do
  #     resources :playlists
  #   end
  # end

  namespace :api do
    namespace :v1 do
      get 'auth', to: "sessions#create"
      post 'login', to: "users#create"

      resources :playlists

      # get 'recent_tracks', to: "users#recent_tracks"
      resources :songs
      get "recent", to: "songs#recent_songs"

      resources :playlist_songs


    end
  end

end


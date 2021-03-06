Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users
      post '/login', to: 'authentication#login'
      get '/logout/:id', to: 'users#logout'
      get '/confirmed/:auth_token', to: 'users#email_confirmation'
    end
  end
  mount ActionCable.server => '/cable'
  resources :conversations, only: [:index, :create]
  resources :messages, only: [:create]
end

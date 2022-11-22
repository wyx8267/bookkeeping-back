Rails.application.routes.draw do
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get '/', to: "home#index"
  namespace :api do
    namespace :v1 do
      resources :validation_codes, only: [:create]
      resources :sessions, path: 'session', only: [:create, :destroy]
      resources :me, only: [:show]
      resources :items
      resources :tags
    end
  end
end

Rails.application.routes.draw do
  root "home#index"

  # Search
  post "search", to: "recipes#search"

  # Authentication
  get "signup", to: "users#new"
  resources :users, only: [:create]
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Favorites
  get "favorites", to: "favorites#index"
  post "recipes/:id/favorite", to: "favorites#create", as: "favorite"
  delete "recipes/:id/unfavorite", to: "favorites#destroy", as: "unfavorite"

  # Recipes
  resources :recipes, except: [:index]
  get "recipes", to: "recipes#index"
end

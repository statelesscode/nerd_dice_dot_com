# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "authenticated", to: "authenticated#index", as: "authenticated"
  # paths that do not require authentication
  get "welcome", to: "welcome#index", as: "welcome"

  # paths that require authentication

  # devise
  devise_for :users

  # Defines the root path route ("/")
  root "welcome#index"
end

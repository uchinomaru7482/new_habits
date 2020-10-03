Rails.application.routes.draw do
  devise_for :users
  get "/", to: "static_pages#home"
  get "/lp", to: "static_pages#lp"
  get "/help", to: "static_pages#help"
  get "/users/:id", to: "users#show"
  
  resources :users, only: [:show] do
  	get "/following", to: "users#following" 
  	get "/followers", to: "users#followers"
  end
  resources :habits do
    resources :posts, only: [:new, :create]
  end
  resources :posts, only: [:destroy]
  resources :relationships, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => "users/registrations"
  }
  root to: "static_pages#home"
  get "/lp", to: "static_pages#lp"
  get "/help", to: "static_pages#help"
  get "/terms_of_service", to: "static_pages#terms_of_service"
  get "/privacy_policy", to: "static_pages#privacy_policy"

  resources :users, only: [:show] do
  	get "/following", to: "users#following" 
  	get "/followers", to: "users#followers"
  end
  resources :habits do
    resources :posts, only: [:new, :create]
    get :search, on: :collection
  end
  resources :posts, only: [:show, :destroy] do
    resources :comments, only: [:create]
  end
  resources :comments, only: [:destroy]
  resources :relationships, only: [:create, :destroy]
end

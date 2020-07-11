Rails.application.routes.draw do
  devise_for :users
  get "/", to: "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/users/:id", to: "users#show"
  post "/achievements/:id", to: "achievement#create"

  resources :habits do
    resources :posts, only: [:new, :create]
  end
  resources :posts, only: [:destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

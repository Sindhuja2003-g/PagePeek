Rails.application.routes.draw do
  # Root path
  root "books#index"

  # Authentication
  
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create" 
  delete "logout", to: "sessions#destroy", as: :logout
  
  resources :users, only: [:new, :create]
  get "signup", to: "users#new", as: :signup

  resource :profile, only: [:edit, :update, :destroy]

 
  resources :books do
    resources :reviews, except: [:index, :new, :show] 
  end

  
  get "my_reviews", to: "reviews#my_reviews", as: :my_reviews

 
  post "likes", to: "likes#create"
  delete "likes", to: "likes#destroy"


  resources :genres, only: [:index, :show]


  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end

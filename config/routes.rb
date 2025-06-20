Rails.application.routes.draw do
  # Root path
  root "books#index"

  # Authentication (Sessions)
  get    "login",  to: "sessions#new", as: :login
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout


  get  "signup", to: "users#new",    as: :signup  
  post "users",  to: "users#create", as: :users    


  resource :profile, only: [:edit, :update, :destroy]


  resources :books do
    resources :reviews, except: [:index, :new, :show] 
  end

  get "my_reviews", to: "reviews#my_reviews", as: :my_reviews

  post   "likes", to: "likes#create",  as: :likes
  delete "likes", to: "likes#destroy"


  resources :genres, only: [:index, :show]

  # Health check & PWA
  get "up",              to: "rails/health#show",         as: :rails_health_check
  get "service-worker",  to: "rails/pwa#service_worker",  as: :pwa_service_worker
  get "manifest",        to: "rails/pwa#manifest",        as: :pwa_manifest
end

Rails.application.routes.draw do
   devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Root path
  root "books#index"


  use_doorkeeper do
  skip_controllers :authorizations, :applications, :authorized_applications
  end




namespace :api do
  namespace :v1 do
    resources :books do
      collection do
        get :most_viewed
      end
    end
  end
end



resources :wishlists, only: [:index, :create, :destroy]


  devise_for :users
  resource :profile, only: [:edit, :update, :destroy] 
  get 'profiles/:id', to: 'profiles#show', as: 'public_profile' 

  resources :books do
    resources :reviews, except: [:index, :new, :show] 
  end

  get "my_reviews", to: "reviews#my_reviews", as: :my_reviews

  post   "likes", to: "likes#create",  as: :likes
  delete "likes", to: "likes#destroy"
  


  resources :genres

  # Health check & PWA
  get "up",              to: "rails/health#show",         as: :rails_health_check
  get "service-worker",  to: "rails/pwa#service_worker",  as: :pwa_service_worker
  get "manifest",        to: "rails/pwa#manifest",        as: :pwa_manifest
end

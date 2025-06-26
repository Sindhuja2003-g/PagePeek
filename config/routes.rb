Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Root path
  root "books#index"


  use_doorkeeper 


namespace :admin do
  resources :books do
    member do
      get 'details' 
    end
  end
end



  post   'wishlist/add',    to: 'wishlists#add',    as: :add_to_wishlist
  delete 'wishlist/remove', to: 'wishlists#remove', as: :remove_from_wishlist
  get    'my_wishlist',     to: 'wishlists#index',  as: :my_wishlist

  devise_for :users
  
  resource :profile, only: [:edit, :update, :destroy] 
  get 'profiles/:id', to: 'profiles#show', as: 'public_profile' 

  resources :books do
    resources :reviews, except: [:index, :new, :show] 
  end

#api
namespace :api do
  namespace :v1 do
    resources :books do
      collection do
        get :most_viewed
      end
    end
  end
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

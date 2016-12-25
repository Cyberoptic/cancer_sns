Rails.application.routes.draw do
  root 'static#home'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :users, only: :show do  
    namespace :friend do      
      resources :request_acceptances, only: :create
      resources :requests, only: :create
    end
  end
  
  # Friend Requests
  namespace :friend do
    resources :friendships, only: :destroy
    resources :request_acceptances, only: :destroy
    resources :requests, only: :destroy
  end
end

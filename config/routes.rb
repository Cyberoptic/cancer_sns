Rails.application.routes.draw do
  authenticated :user do
    root 'posts#index'
  end

  root 'static#home'

  resources :posts do
    resources :comments
    resources :likes, only: :create
    resources :unlikes, only: :create
    resources :sads, only: :create
    resources :unsads, only: :create
    resources :happies, only: :create
    resources :unhappies, only: :create    
  end

  resources :likes, only: :destroy 
  resources :sads, only: :destroy
  resources :happies, only: :destroy

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "registrations" }
  
  resources :users, only: [:show, :index]  do  
    get 'pending_requests', to: 'users#pending_requests'
    get 'friends', to: 'users#friends'

    # Friendships
    scope module: 'friend' do    
      resources :request_acceptances, only: :create
      resources :request_declinals, only: :create
      resources :unfriendings, only: :create
      resources :requests, only: [:create, :destroy]
    end
  end  

end

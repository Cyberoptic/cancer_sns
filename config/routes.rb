Rails.application.routes.draw do
  authenticated :user do
    root 'posts#index'
  end

  root 'static#home'

  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :sads, only: [:create, :destroy]
    resources :happies, only: [:create, :destroy]    
  end

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "registrations" }
  
  resources :users, only: [:show, :index]  do  
    # Friendships
    scope module: 'friend' do    
      resources :request_acceptances, only: :create
      resources :request_declinals, only: :create
      resources :unfriendings, only: :create
      resources :requests, only: [:create, :destroy]
    end
  end

end

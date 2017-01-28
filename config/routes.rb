Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  authenticated :user do
    root 'posts#index'
  end

  root 'static#home'

  resources :posts, except: [:new, :show, :edit] do
    post :comments, to: "posts/comments#create"
    post :likes, to: "posts/likes#create"
    post :happies, to: "posts/happies#create"
    post :sads, to: "posts/sads#create"
    post :unlikes, to: "posts/unlikes#create"
    post :unsads, to: "posts/unsads#create"
    post :unhappies, to: "posts/unhappies#create"

    member do
      get 'more_comments'
    end
  end

  resources :comments, only: [:update, :destroy] do
    post :visibility_toggles, to: "comments/visibility_toggles#create" 
  end

  resources :chat_rooms, only: [:show, :index]
  resources :chat_room_searches, only: :create

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "registrations" }
  
  resources :users, only: [:show, :index]  do  
    get 'pending_requests', to: 'users#pending_requests'
    get 'friends', to: 'users#friends'
    resources :chat_rooms, only: :create

    # Friendships
    scope module: 'friend' do    
      resources :request_acceptances, only: :create
      resources :request_declinals, only: :create
      resources :unfriendings, only: :create
      resources :requests, only: [:create, :destroy]
    end
  end  

  resources :groups do
    resources :group_memberships, only: :create
    resources :group_unmemberships, only: :create
    resources :group_posts, as: :posts, only: [:create]
  end

  resources :group_posts, only: [:edit, :update, :destroy] do
    post :comments, to: "group_posts/comments#create"
    post :likes, to: "group_posts/likes#create"
    post :happies, to: "group_posts/happies#create"
    post :sads, to: "group_posts/sads#create"
    post :unlikes, to: "group_posts/unlikes#create"
    post :unsads, to: "group_posts/unsads#create"
    post :unhappies, to: "group_posts/unhappies#create"
  end

end

Rails.application.routes.draw do  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount ActionCable.server => '/cable'

  authenticated :user do
    root 'posts#index'
  end

  root 'static#home'

  resources :posts, except: [:new, :edit] do
    post :comments, to: "posts/comments#create"
    post :likes, to: "posts/likes#create"
    post :happies, to: "posts/happies#create"
    post :sads, to: "posts/sads#create"
    post :mads, to: "posts/mads#create"
    post :unlikes, to: "posts/unlikes#create"
    post :unsads, to: "posts/unsads#create"
    post :unhappies, to: "posts/unhappies#create"
    post :unmads, to: "posts/unmads#create"

    resources :emotions, only: :index
    
    member do
      get 'more_comments'
    end
  end  

  resources :comments, only: [:update, :destroy] do
    post :visibility_toggles, to: "comments/visibility_toggles#create" 
  end

  resources :chat_rooms, only: [:show, :index] do
    resources :messages, only: :create
    member do
      get 'load_more'
    end
  end
  resources :chat_room_searches, only: :create

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "registrations" }
  
  get 'users/sign_up/top' => 'high_voltage/pages#show', id: 'sign_up'

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

  scope module: 'friend' do
    resources :requests, only: :index
  end

  resources :groups do
    resources :group_memberships, only: [:index, :create]
    resources :group_unmemberships, only: :create
    resources :group_posts, as: :posts, only: [:create]
    resources :group_invitations, only: [:index, :new, :create, :destroy]
  end

  get '/discover/groups', to: 'group_discoveries#index'

  resources :group_memberships, only: [:update, :destroy]

  resources :group_posts, only: [:show, :edit, :update, :destroy] do
    post :comments, to: "group_posts/comments#create"
    post :likes, to: "group_posts/likes#create"
    post :happies, to: "group_posts/happies#create"
    post :sads, to: "group_posts/sads#create"
    post :mads, to: "group_posts/mads#create"
    post :unlikes, to: "group_posts/unlikes#create"
    post :unsads, to: "group_posts/unsads#create"
    post :unhappies, to: "group_posts/unhappies#create"
    post :unmads, to: "group_posts/unmads#create"
  end

  resources :notifications, only: :index do
    collection do
      post :mark_as_read
    end
  end

  resources :news_articles, only: [:index, :show]
end

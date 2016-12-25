Rails.application.routes.draw do
  root 'static#home'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  resources :users, only: :index
end

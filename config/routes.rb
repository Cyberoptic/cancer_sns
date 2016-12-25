Rails.application.routes.draw do
  root 'static#home'
<<<<<<< HEAD
  resources :posts
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
=======

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "registrations" }
  
  resources :users, only: :index
>>>>>>> 95181f0bbb41ff422e65efb432457a1dba77648d
end

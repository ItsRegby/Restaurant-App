Rails.application.routes.draw do

  get "home", to: "home#home"

  get "password", to: "password#edit", as: "edit_password"
  patch "password", to: "password#update"
  post "password", to: "password#create"

  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  delete "logout", to: "sessions#destroy"

  get "password/reset", to: "password_reset#new"
  post "password/reset", to: "password_reset#create"

  get "password/reset/edit", to: "password_reset#edit"
  patch "password/reset/edit", to: "password_reset#update"

  get "profile/edit", to: "profile#edit"
  patch "profile/edit", to: "profile#update"
  post "profile/edit", to: "profile#create"

  get '/menu', to: 'menu#index', as: 'menu'
  get '/menu/:category_id', to: 'menu#category', as: 'menu_category'

  get 'categories', to: 'categories#index'

  post 'add_to_cart', to: 'items#add_to_cart', as: :add_to_cart
  
  resource :cart, only: [:show] do
    delete 'clear', on: :collection
  end

end

Rails.application.routes.draw do

  get "home", to: "home#home"

  get "profile", to: "profiles#edit", as: "edit_profile"
  patch "profile", to: "profiles#update"
  post "profile", to: "profiles#create"

  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  delete "logout", to: "sessions#destroy"

  get "password/reset", to: "password_reset#new"
  post "password/reset", to: "password_reset#create"
  get "password/reset/edit", to: "password_reset#edit"
  patch "password/reset/edit", to: "password_reset#update"
end

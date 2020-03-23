Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "users/", to: "users#list"
  post "users/", to: "users#create"
  get "users/:id", to: "users#find"
  patch "users/:id", to: "users#update"
  delete "users/:id", to: "users#delete"
end

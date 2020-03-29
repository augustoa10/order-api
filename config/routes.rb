Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # User routes

  get "/users", to: "users#list"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#find"
  patch "/users/:id", to: "users#update"
  delete "/users/:id", to: "users#delete"

  # Device Routes

  get "devices", to: "devices#list"

  # Plan routes

  get "/plans", to: "plans#list"
  post "/plans", to: "plans#create"
  get "/plans/:id", to: "plans#find"
  patch "/plans/:id", to: "plans#update"
  delete "/plans/:id", to: "plans#delete"

  # Order routes

  get "/orders", to: "orders#list"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#find"
  patch "/orders/:id", to: "orders#update"
  delete "/orders/:id", to: "orders#delete"
end

Rails.application.routes.draw do
  get "search/index"
  devise_for :users
  
  root "home#index"
  

  get "/inquiry", to: "inquiry#inquiry", as: :inquiry
  post "/inquiry", to: "inquiry#create"



  # Pages
  get "/contact", to: "pages#contact", as: :contact
  get "/about", to: "pages#about", as: :about

  # Products routes with custom collection routes
  resources :products do
  collection do
    get :bitumen
  end
  end

  
  

  resources :specifications, only: [:new, :create, :edit, :update, :destroy]
  resources :packings
  resources :grades
  resources :posts
  resources :tags
  resources :post_tags
  resources :inquiry, only: [:new, :create]
  
  get "/search", to: "search#index", as: :search
end
Rails.application.routes.draw do
  get "search/index"
  devise_for :users
  
  root "home#index"
  get "/home", to: "home#index"

  get "/inquiry", to: "inquiry#inquiry", as: :inquiry
  post "/inquiry", to: "inquiry#create"



  # Pages
  get "/contact", to: "pages#contact", as: :contact
  get "/about", to: "pages#about", as: :about
  get "/aboutus", to: "pages#about", as: :aboutus   # Optional - both work

  # Products routes with custom collection routes
  resources :products do
    collection do
      get :bitumen
      get :paraffin_wax
      get :slack_wax
      get :footsoil
      get :base_oil
      get :rpo
    end
  end

  resources :specifications
  # Bitumen sub-products
  get "products/bitumen/oxidized", to: "products#oxidized_bitumen", as: :products_oxidized_bitumen
  get "products/bitumen/penetration", to: "products#penetration_bitumen", as: :products_penetration_bitumen
  get "products/bitumen/cutback", to: "products#cutback_bitumen", as: :products_cutback_bitumen
  get "products/bitumen/emulsion", to: "products#emulsion_bitumen", as: :products_emulsion_bitumen

  resources :specifications, only: [:new, :create, :edit, :update, :destroy]
  resources :packings
  resources :grades
  resources :posts
  resources :tags
  resources :post_tags
  resources :inquiry, only: [:new, :create]
  
  get "/search", to: "search#index", as: :search
end
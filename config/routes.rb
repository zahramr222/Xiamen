Rails.application.routes.draw do
  get "search/index"
  devise_for :users,
           skip: [:registrations],
           controllers: {
             sessions: "users/sessions"
           }
  root "home#index"
  
  post "/newsletter", to: "pages#create_newsletter", as: :newsletter

  get "/inquiry", to: "inquiry#inquiry", as: :inquiry
  post "/inquiry", to: "inquiry#create"



  # Pages
  get "/contact", to: "pages#contact", as: :contact
  post "/contact", to: "pages#create_contact"
  

  get "/about", to: "pages#about", as: :about

  get "/privacy-policy", to: "pages#privacy_policy", as: :privacy_policy

  # Products routes with custom collection routes
  resources :products do
  collection do
    get :bitumen
  end
  end

  
  

  resources :specifications
  resources :packings
  resources :grades
  resources :posts
  resources :tags
  resources :post_tags
  resources :inquiry, only: [:new, :create]
  
  get "/search", to: "search#index", as: :search

  get "sitemap.xml", to: "sitemaps#show", defaults: { format: "xml" }
end
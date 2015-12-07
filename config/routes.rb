Rails.application.routes.draw do

  get 'dashboard/index'

  get 'dashboard/event'

  get 'dashboard/past'

  resources :urls, only: [:new, :create]

  resources :attendees

  get '/terms' => 'pages#terms'
  get '/privacy' => 'pages#privacy'
  
  get '/about' => 'pages#about'
  get '/pricing' => 'pages#pricing'


  get '/attendees/:id', to: 'attendees#index'

  get '/dashboard', to: 'events#index'

  get '/event-create', to: 'events#new'

  devise_for :users, :controllers => {  registrations: "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }


  authenticated do
    root :to => 'dashboard#index', as: :authenticated
  end

  root :to => 'pages#home'

  # resources :users

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
  end

  resources :users do
    resources :events
  end

  post '/attendees/invite', to: 'attendees#invite'
 




  post '/users/:user_id/events/:id/updatetheme', to: 'events#update_theme', :as => :update_event
  put '/users/:user_id/events/:id/updatetheme', to: 'events#update_theme'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

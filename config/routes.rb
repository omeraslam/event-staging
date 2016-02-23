Rails.application.routes.draw do

  resources :themes

  get 'dashboard/index'
  get 'dashboard/event'
  get 'dashboard/past'
  get 'dashboard/profile'
  get 'dashboard/print'
  get 'dashboard/contacts'
  get 'dashboard/thankyou',  to: 'dashboard#thankyou', :as => :thankyou


  resources :urls, only: [:new, :create]

  resources :attendees

  get '/terms' => 'pages#terms'
  get '/privacy' => 'pages#privacy'
  get '/pricing' => 'pages#pricing'

  get '/events/calendar'  => 'events#calendar'
  
  get '/about' => 'pages#about'
  get '/upgrade' => 'dashboard#upgrade', :as => :upgrade


  get '/attendees/:id', to: 'attendees#index'

  get '/dashboard', to: 'events#index', :as => :dashboard

  get '/create', to: 'events#new', :as => :create

  devise_for :users, :controllers => {  registrations: "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }


  authenticated do
    #root :to => 'dashboard#index', as: :authenticated
  end


  #get '', to: 'events#show', constraints: {subdomain: /.+/}

  root :to => 'pages#home'

  # resources :users

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
  end
  resources :users
  resources :events
  get '/:slug' => 'events#show', :as => :slugger

  get '/:slug/export' => 'events#export_events', :as => :export_events

  # resources :users do
  #   resources :events
  # end

  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end

  post '/attendees/invite', to: 'attendees#invite'
  put '/attendees/:id/reply', to: 'attendees#reply', :as => :attendee_reply

  post '/attendees/send-invite', to: 'attendees#send_invite'


  post '/:slug/contact-host', to: 'events#contact_host', :as => :contact_host
 


  post '/users/:user_id/charge-card', to: 'users#charge_card', :as => :user_charge
  put '/users/:user_id/cancel-subscription', to: 'users#cancel_subscription', :as => :cancel_subcription


  patch '/:slug/updatetheme', to: 'events#update_theme', :as => :update_event
  post '/:slug/updatetheme_post', to: 'events#update_theme', :as => :update_event_post

  put '/:slug/updatetheme', to: 'events#update_theme'

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
  #   
  
  #match ':controller(/:action(/:id))', :via => :get
end

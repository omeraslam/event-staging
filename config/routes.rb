Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #resources :themes

  #dashboard routes
  get 'dashboard/index'
  get 'dashboard/event'
  #get 'dashboard/past'
  get 'dashboard/profile'
  get 'dashboard/print'
  get 'dashboard/contacts'

  #payment routes
  get '/thank-you',  to: 'payments#thankyou', :as => :thankyou
  get '/upgrade' => 'payments#upgrade', :as => :upgrade
  get '/cancel' => 'payments#cancel', :as => :cancel





  resources :urls, only: [:new, :create]

  resources :attendees

  get '/terms' => 'pages#terms'
  get '/privacy' => 'pages#privacy'
  get '/pricing' => 'pages#pricing'
  get '/features' => 'pages#features'
  get '/explore' => 'pages#explore'
  get '/contact' => 'pages#contact'
  #sget '/error404.html' => 'pages#error404', :as => :error_path


  get '/dashboard' => 'dashboard#index'


  get '/events/calendar'  => 'events#calendar'
  
  get '/about' => 'pages#about'


  get '/attendees/:id', to: 'attendees#index'

  # get '/dashboard', to: 'events#index', :as => :dashboard

  get '/create', to: 'events#new', :as => :create

  devise_for :users, :controllers => {  registrations: "registrations", sessions: "sessions", :omniauth_callbacks => "users/omniauth_callbacks" }








  authenticated do
    root :to => 'dashboard#index', as: :authenticated
  end

  root :to => 'pages#home'

  #get '', to: 'events#show', constraints: {subdomain: /.+/}


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
      patch 'update_email'
    end
  end


  post '/attendees/send-preview', to: 'attendees#send_preview', :as => :send_preview

  post '/attendees/invite', to: 'attendees#invite'
  put '/attendees/:id/reply', to: 'attendees#reply', :as => :attendee_reply

  post '/attendees/send-invite', to: 'attendees#send_invite'
  post '/attendees/batch-invite', to: 'attendees#batch_invite'


  post '/events/check-slug', to: 'events#check_slug'

  post '/:slug/contact-host', to: 'events#contact_host', :as => :contact_host


 


  post '/users/:user_id/charge-card', to: 'users#charge_card', :as => :user_charge
  post '/users/:user_id/update-subscription', to: 'users#update_subscription', :as => :update_subscription
  post '/users/:user_id/cancel-subscription', to: 'users#cancel_subscription', :as => :cancel_subscription


  patch '/:slug/updatetheme', to: 'events#update_theme', :as => :update_event
  post '/:slug/updatetheme_post', to: 'events#update_theme', :as => :update_event_post

  put '/:slug/updatetheme', to: 'events#update_theme'

  get '/:slug/unsplash-search', to: 'events#unsplash_search'


end

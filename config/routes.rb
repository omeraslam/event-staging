Rails.application.routes.draw do

  resources :coupons

  resources :accounts

  resources :line_items

  resources :purchases

  resources :buyers

  resources :tickets

  #constraints(CheckoutSubdomain) do
    get '/:slug/select-buy' => 'events#select_buy' , :as => :select_buy
  #end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #resources :themes
  
  class CustomDomainConstraint
    def self.matches? request
      matching_site?(request)
    end

    def self.matching_site? request

        puts "REQUEST SUBDOMAIN:: #{request.subdomain}"
      if ((request.domain != ENV['SITE_URL']))
        puts "REQUEST DOMAIN:: #{request.domain}"
        puts "SITE URL:: #{ENV['SITE_URL']}"
        Event.where(:domain => request.host).any? || User.where(:domain => request.host).any?
      elsif ((request.subdomain.present? && request.subdomain != 'www'))
        if(Event.where(:slug => request.subdomain).any? || User.where(:domain => request.host ).any? )
          Event.where(:slug => request.subdomain).any? || User.where(:domain => request.host ).any?
        else 
          User.where(:domain => request.host ).any? || User.where(:subdomain => request.subdomain).any? 
        end
      end
    end
  end 

  #|r| (r.subdomain.present? && r.subdomain != 'www') || r.host == 'www.markbushyphotography.com'

  #get '', :to => 'events#home', :constraints => CustomDomainConstraint, via: :get 
  #match '/users/:id/events/index' => 'events#home', :constraints => CustomDomainConstraint, via: :all
  # match ':domain', to: 'pages#home', :constraints => CustomDomainConstraint, via: :all  
  

  #dashboard routes
  get 'dashboard/index'
  post ':slug/choose-tickets' => 'events#choose_tickets', :as => :events_choose_tickets
  get 'dashboard/event'
  get 'dashboard/profile'
  get 'dashboard/print'
  get 'dashboard/contacts'
  get '/dashboard' => 'dashboard#index'
  get '/event-maker' => 'pages#event'

  get '/robots.:format' => 'pages#robots'
  get '/sitemap.xml.gz', to: redirect("https://#{ENV['S3_BUCKET_NAME']}.s3.amazonaws.com/sitemaps/sitemap.xml.gz"), as: :sitemap

  #payment routes
  get '/thank-you',  to: 'payments#thankyou', :as => :thankyou
  get '/upgrade' => 'payments#upgrade', :as => :upgrade
  get '/cancel' => 'payments#cancel', :as => :cancel
  get '', to: 'events#show', constraints: CustomDomainConstraint, :as => :events_subdomain
  #get '', to: 'events#home', constraints: lambda { |r| (r.subdomain.present? && r.subdomain != 'www') || r.host == 'www.markbushyphotography.com' }, :as => :events_subdomain
  get '/users/:id/events/index', to: 'events#home', :as => :events_home
 

  #get '', to: 'events#show', constraints: {subdomain: /.+/}


  #ticket buying
  get '/buy' => 'payments#buy', :as => :buy


  #bitly url
  resources :urls, only: [:new, :create]

  #attendee routes
  resources :attendees

  #attendee custom routes
  post '/attendees/send-preview', to: 'attendees#send_preview', :as => :send_preview
  post '/attendees/invite', to: 'attendees#invite'
  put '/attendees/:id/reply', to: 'attendees#reply', :as => :attendee_reply
  post '/attendees/send-invite', to: 'attendees#send_invite'
  post '/attendees/batch-invite', to: 'attendees#batch_invite'



  #static pages
  #scope :constraints => { :protocol => "https" } do
    get '/terms' => 'pages#terms'
    get '/privacy' => 'pages#privacy'
    get '/pricing' => 'pages#pricing'
    get '/features' => 'pages#features'
    get '/explore' => 'pages#explore'
    get '/contact' => 'pages#contact'
    get '/facebookevents' => 'pages#facebook'
    get '/about' => 'pages#about'
    get '/press' => 'pages#press'
    get '/customization' => 'pages#customization'
  #end

  get '/error404' => 'pages#error404', :as => :error_path

  get '/connect/redirect' => 'events#stripe_redirect', :as => :stripe_redirect




  get '/events/calendar'  => 'events#calendar'
  get '/create', to: 'events#new', :as => :create
  


  get '/attendees/:id', to: 'attendees#index'



  devise_for :users, :controllers => {  registrations: "registrations", sessions: "sessions", :omniauth_callbacks => "users/omniauth_callbacks" }

  authenticated do
    root :to => 'dashboard#index', as: :authenticated
  end

  root :to => 'pages#home'
 


  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
  end


  
  resources :users, :shallow => true do
    resources :events do
       resources :tickets
    end
  end

  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
      patch 'update_email'
      patch 'update'
    end
  end

 

  #user stripe routes
  post '/users/:user_id/charge-card', to: 'users#charge_card', :as => :user_charge
  post '/users/:user_id/update-subscription', to: 'users#update_subscription', :as => :update_subscription
  post '/users/:user_id/cancel-subscription', to: 'users#cancel_subscription', :as => :cancel_subscription


  post '/events/check-slug', to: 'events#check_slug'
  post '/:slug/contact-host', to: 'events#contact_host', :as => :contact_host
  #slug 
  post '/:slug/tickets' => 'tickets#create', :as => :slug_create
  delete '/:slug/purchases/:id' => 'purchases#destroy', :as => :slug_purchase_destroy
  #/purchases/:id(.:format)  purchases#destroy
  get '/:slug' => 'events#show', :as => :slugger
  get '/:slug/export' => 'events#export_events', :as => :export_events
  patch '/users/:id/update', to: 'users#update', :as => :update_user
  patch '/:slug/updatetheme', to: 'events#update_theme', :as => :update_event
  post '/:slug/updatetheme_post', to: 'events#update_theme', :as => :update_event_post
  put '/:slug/updatetheme', to: 'events#update_theme'
  get '/:slug/unsplash-search', to: 'events#unsplash_search'
  post '/:slug/coupons' => 'coupons#create', :as => :coupon_create
  post '/coupons/:id/edit' => 'coupons#update'
  post '/check-coupon' => 'events#check_coupon'


  #buy tickets
  #get '/:slug/select-tickets' => 'events#select_tickets' , :as => :select_tickets
  post '/:slug/select-tickets' => 'events#select_tickets' , :as => :select_tickets
  post '/:slug/complete-registration' => 'events#complete_registration' , :as => :complete_registration
  
   post '/:slug/submit-attendees' => 'events#submit_attendees' , :as => :submit_attendees
  

  get '/:slug/buy' => 'events#show_buy' , :as => :show_buy
  get '/:slug/confirm' => 'events#show_confirm' , :as => :show_confirm
  get '/:slug/ticket' => 'events#show_ticket' , :as => :show_ticket
  get '/:slug/confirm-ticket' => 'events#confirm_ticket' , :as => :confirm_ticket
  post '/tickets/:id/edit' => 'tickets#update'

  get '/oauth/callback' do 
    code = params[:code]
    @resp = settings.client.auth_code.get_token(code, :params => {:scope => 'read_write'})
    @access_token = @resp.token
    
  end



end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location
  before_action :check_member_type
  add_flash_types :event_success
  

  helper :all



end



def check_member_type
  if user_signed_in?

    # check if membership is active



    member_type = current_user.plan_type
    case member_type
    when 'basic'
      @event_limit = ENV['BASIC_EVENT_LIMIT'].to_i
      @event_registration_limit = ENV['BASIC_REGISTRATION_LIMIT'].to_i
    when 'premium'
      @event_limit = ENV['PREMIUM_EVENT_LIMIT'].to_i
      @event_registration_limit = ENV['PREMIUM_REGISTRATION_LIMIT'].to_i
    when 'pro'
      @event_limit = ENV['PRO_EVENT_LIMIT'].to_i
      @event_registration_limit = ENV['PRO_REGISTRATION_LIMIT'].to_i

    when 'enterprise'
      @event_limit = ENV['ENTERPRISE_EVENT_LIMIT'].to_i
      @event_registration_limit = ENV['ENTERPRISE_REGISTRATION_LIMIT'].to_i
    else
      @event_limit = ENV['BASIC_EVENT_LIMIT'].to_i
      @event_registration_limit = ENV['BASIC_REGISTRATION_LIMIT'].to_i
    end



    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    @count_events = Event.where(:user_id => current_user.id.to_s).count
    @count_registrations = Attendee.where(:user_id => current_user.id.to_s).count

    if @count_events < @event_limit && @count_registrations   < @event_registration_limit
      @disable_create = false

    else 
      @disable_create = true

    end


    @is_premium = current_user.premium? ? 'active': ''



    # else if membership not active


    # end



    if !current_user.customer_id.nil?
      @cu = Stripe::Customer.retrieve(current_user.customer_id)
      
    else
      @cu = ''
    end






  end 
end

def render_404
  render file: "#{Rails.root}/public/404.html", layout: false, status: 404
end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end  
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end





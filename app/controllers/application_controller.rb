class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location
  before_action :check_member_type
  

  helper :all


 # protected
 #  def authenticate_user!(options={})
 #    if user_signed_in?
 #      super(options)

 #    else
 #      redirect_to new_user_registration_path, :notice => 'Please login to create event'
 #      ## if you want render 404 page
 #      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
 #    end
 #  end


end

def check_member_type
  if user_signed_in?

    # check if membership is active



    member_type = current_user.plan_type
    case member_type
    when 'basic'
      @event_limit = 1
      event_registration_limit = 50
    when 'premium'
      @event_limit = 3
      event_registration_limit = 500
    when 'pro'
      @event_limit = nil
      event_registration_limit = 5000

    when 'enterprise'
      @event_limit = nil
      event_registration_limit = 15000
    else
      @event_limit = 1
      event_registration_limit = 50
    end

    logger.debug "Num events is: #{@event_limit}"
    logger.debug "Num registrations is: #{event_registration_limit}"


    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    @count_events = Event.where(:user_id => current_user.id.to_s).count

    if @count_events < @event_limit
      @disable_create = false

    else 
      @disable_create = true

    end


    logger.debug "Disable create is: #{@disable_create}"

    @cu = ''
    @is_premium = false

    # else if membership not active


    # end



    # if !current_user.customer_id.nil?
    #   @cu = Stripe::Customer.retrieve(current_user.customer_id)
    #   logger.debug "app level customer id: #{@cu.id}"
    #   @is_premium = @cu.subscriptions.data[0].nil? ? false : @cu.subscriptions.data[0].status

    #   logger.debug "current user: #{current_user}"

    #   @disable_create = @count_events.count > 0 && @is_premium != 'active'
    #   logger.debug "app level customer id: #{@disable_create}"
    # else
    #   @cu = ''
    #   @is_premium = false
    #   @disable_create = @count_events.count > 0
    # end






  end 
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





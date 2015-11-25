class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location
  

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





#def current_root_class
#  'class=pages' if controller_name == "pages"
#  
#end 


def current_root_class
	case controller_name
		when 'pages'
			 'class=pages'
		when 'registrations'
			 'class=registration'
		when 'events'
			 'class=events'
		else 
			 'class=standard'
		end
end 




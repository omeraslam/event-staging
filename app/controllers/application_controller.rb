class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper :all

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
